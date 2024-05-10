//
//  IrregularEventViewController.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 02.05.2024.
//

import UIKit

protocol IrregularEventViewControllerDelegate: AnyObject {
    func addNewIrregular(_ trackerCategory: TrackerCategory)
}

// Controller for irregular event creating
final class IrregularEventViewController: UIViewController {
    
    // MARK: - Variables
    
    weak var delegate: IrregularEventViewControllerDelegate?
    
    private let colors: [UIColor] = [
        .ypColorSelection1, .ypColorSelection2, .ypColorSelection3,
        .ypColorSelection4, .ypColorSelection5, .ypColorSelection6,
        .ypColorSelection7, .ypColorSelection8, .ypColorSelection9,
        .ypColorSelection10, .ypColorSelection11, .ypColorSelection12,
        .ypColorSelection13, .ypColorSelection14, .ypColorSelection15,
        .ypColorSelection16, .ypColorSelection17, .ypColorSelection18
    ]
    private let emoji = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                         "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let irregularTextField: UITextField = {
        let irregularTextField = UITextField()
        irregularTextField.translatesAutoresizingMaskIntoConstraints = false
        irregularTextField.backgroundColor = UIColor(named: "YP Background (day)")
        irregularTextField.textColor = UIColor(named: "YP Black (day)")
        irregularTextField.clearButtonMode = .whileEditing
        irregularTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: irregularTextField.frame.height))
        irregularTextField.leftViewMode = .always
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "YP Gray") as Any]
        irregularTextField.attributedPlaceholder = NSAttributedString(string: "Введите название трекера", attributes: attributes)
        irregularTextField.layer.masksToBounds = true
        irregularTextField.layer.cornerRadius = 16
        
        return irregularTextField
    }()
    
    private let irregularTableView: UITableView = {
        let irregularTableView = UITableView()
        irregularTableView.translatesAutoresizingMaskIntoConstraints = false
        irregularTableView.backgroundColor = UIColor(named: "YP White (day)")
        
        return irregularTableView
    }()
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor(named: "YP Red"), for: .normal)
        cancelButton.layer.borderColor = UIColor(named: "YP Red")?.cgColor
        cancelButton.layer.borderWidth = 2.0
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = 16
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cancelButton.addTarget(nil, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return cancelButton
    }()
    
    private let createIrregular: UIButton = {
        let createIrregularButton = UIButton()
        createIrregularButton.translatesAutoresizingMaskIntoConstraints = false
        createIrregularButton.setTitle("Создать", for: .normal)
        createIrregularButton.setTitleColor(UIColor(named: "YP White (day)"), for: .normal)
        createIrregularButton.backgroundColor = UIColor(named: "YP Gray")
        createIrregularButton.layer.cornerRadius = 16
        createIrregularButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        createIrregularButton.isEnabled = false
        createIrregularButton.addTarget(nil, action: #selector(createIrregularButtonTapped), for: .touchUpInside)
        
        return createIrregularButton
    }()
    
    private let emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(IrregularEmojiCell.self, forCellWithReuseIdentifier: "Irregular emoji cell")
        collectionView.register(IrregularEmojiHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IrregularEmojiHeader.id)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(IrregularColorCell.self, forCellWithReuseIdentifier: "Irregular color cell")
        collectionView.register(IrregularColorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IrregularColorHeader.id)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let header: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
     //   header.text = "Новое нерегулярное событие"
        header.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        header.textColor = UIColor(named: "YP Black (day)")
        return header
    }()
    
    private var category: String?
    private var chosenCategoryIndex: Int?
    private var chosenDays: [Int] = Array(0...6)
    
    // MARK: - Methods
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createIrregularButtonTapped() {
        guard   let text: String = irregularTextField.text,
                    let category: String = category,
                    let emoji = selectedEmoji,
                    let color = selectedColor
        else { return }
        if let delegate = delegate {
            delegate.addNewIrregular(TrackerCategory(header: category, trackersArray: [Tracker(id: UUID(), name: text, color: color, emoji: emoji, schedule: chosenDays)]))
        } else {
            print("Delegate error")
        }
        dismiss(animated: true)
    }
    
    private func checkButtonAccessibility() {
        if let text = irregularTextField.text,
           !text.isEmpty,
           category != nil {
            createIrregular.isEnabled = true
            createIrregular.backgroundColor = UIColor(named: "YP Black (day)")
            createIrregular.setTitleColor(UIColor(named: "YP White (day)"), for: .normal)
        } else {
            createIrregular.isEnabled = true
            createIrregular.backgroundColor = UIColor(named: "YP Gray")
        }
           
    }
    
    private func setupEmojiCollectionView() {
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
    }
    
    private func setupColorCollectionView() {
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
    }
    
    private func setupIrregularLayout() {
        navigationItem.title = "Новое нерегулярное событие"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YP Black (day)")]
        navigationItem.hidesBackButton = true
        
        irregularTableView.dataSource = self
        irregularTableView.delegate = self
        irregularTableView.register(IrregularEventCell.self, forCellReuseIdentifier: IrregularEventCell.reuseIdentifier)
        irregularTableView.separatorColor = UIColor(named: "YP Gray")
        irregularTableView.separatorStyle = .singleLine
        
        view.addSubview(scrollView)
        scrollView.addSubview(header)
        scrollView.addSubview(irregularTextField)
        scrollView.addSubview(irregularTableView)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        scrollView.addSubview(cancelButton)
        scrollView.addSubview(createIrregular)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            header.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 26),
            header.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            header.heightAnchor.constraint(equalToConstant: 22),
            irregularTextField.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            irregularTextField.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            irregularTextField.heightAnchor.constraint(equalToConstant: 75),
            irregularTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            irregularTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            irregularTableView.topAnchor.constraint(equalTo: irregularTextField.bottomAnchor, constant: 24),
            irregularTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            irregularTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            irregularTableView.heightAnchor.constraint(equalToConstant: 75),
            emojiCollectionView.topAnchor.constraint(equalTo: irregularTableView.bottomAnchor, constant: 32),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -18),
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 222),
            colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -18),
            cancelButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: colorCollectionView.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createIrregular.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            createIrregular.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            createIrregular.heightAnchor.constraint(equalToConstant: 60),
            createIrregular.leadingAnchor.constraint(equalTo: colorCollectionView.centerXAnchor, constant: 4)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //  irregularTextField.delegate = self
        view.backgroundColor = UIColor(named: "YP White (day)")
        setupIrregularLayout()
        setupEmojiCollectionView()
        setupColorCollectionView()
    }
}

extension IrregularEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoryVC = CategoryViewController(chosenCategoryIndex: chosenCategoryIndex)
            categoryVC.delegate = self
            navigationController?.pushViewController(categoryVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension IrregularEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IrregularEventCell.reuseIdentifier, for: indexPath) as! IrregularEventCell
        cell.backgroundColor = UIColor(named: "YP Background (day)")

        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: 0)

        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if indexPath.row == numberOfRows - 1 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))

        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.row == lastRowIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        }
    }

}

extension IrregularEventViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if category == nil {
            showReminderAlert()
            textField.resignFirstResponder()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkButtonAccessibility()
        irregularTextField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder() // Closing keyboard
    }

    private func showReminderAlert() {
        let alertController = UIAlertController(title: "Напоминание", message: "Сначала выберите Категорию", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension IrregularEventViewController: CategoryViewControllerDelegate {
    func addCategory(_ category: String, index: Int) {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = irregularTableView.cellForRow(at: indexPath) as? IrregularEventCell {
            cell.detailTextLabel?.text = category
        }
        self.category = category
        chosenCategoryIndex = index
        checkButtonAccessibility()
    }
}

extension IrregularEventViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Irregular emoji cell", for: indexPath) as? IrregularEmojiCell else {
                return UICollectionViewCell()
            }
            let emojiIndex = indexPath.item % emoji.count
            let selectedEmoji = emoji[emojiIndex]
            
            cell.emojiLabel.text = selectedEmoji
            cell.layer.cornerRadius = 16
            
            return cell
        } else if collectionView == colorCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Irregular color cell", for: indexPath) as? IrregularColorCell else {
                return UICollectionViewCell()
            }
            
            let colorIndex = indexPath.item % colors.count
            let selectedColor = colors[colorIndex]
            
            cell.colorView.backgroundColor = selectedColor
            cell.layer.cornerRadius = 8
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView:UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView == emojiCollectionView {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: IrregularEmojiHeader.id, for: indexPath) as? IrregularEmojiHeader else {
                return UICollectionReusableView()
            }
            header.headerText = "Emoji"
            return header
        } else if collectionView == colorCollectionView {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: IrregularColorHeader.id, for: indexPath) as? IrregularColorHeader else {
                return UICollectionReusableView()
            }
            header.headerText = "Цвет"
            return header
        }
        
        return UICollectionReusableView()
    }
    
}

extension IrregularEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? IrregularEmojiCell
            cell?.backgroundColor = UIColor(named: "YP Light Gray")
            
            selectedEmoji = cell?.emojiLabel.text
        } else if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? IrregularColorCell
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = cell?.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
            
            selectedColor = cell?.colorView.backgroundColor
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? IrregularEmojiCell
            cell?.backgroundColor = UIColor(named: "YP White (day)")
        } else if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? IrregularColorCell
            cell?.layer.borderWidth = 0
        }
    }
}
