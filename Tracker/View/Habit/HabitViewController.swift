//
//  HabitViewController.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 02.05.2024.
//

import UIKit

protocol HabitViewControllerDelegate: AnyObject {
    func addNewHabit(_ trackerCategory: TrackerCategory)
    func appendTracker(tracker: Tracker)
    func reload()
}

// Controller for habit creating
final class HabitViewController: UIViewController {
    
    // MARK: - Variables
    weak var delegate: HabitViewControllerDelegate?
    private var trackersVC: HabitViewControllerDelegate?
    
    private var selectedColor: UIColor?
    private var selectedEmoji: String?
    
    private let colors: [UIColor] = [
        .ypColorSelection1, .ypColorSelection2, .ypColorSelection3,
        .ypColorSelection4, .ypColorSelection5, .ypColorSelection6,
        .ypColorSelection7, .ypColorSelection8, .ypColorSelection9,
        .ypColorSelection10, .ypColorSelection11, .ypColorSelection12,
        .ypColorSelection13, .ypColorSelection14, .ypColorSelection15,
        .ypColorSelection16, .ypColorSelection17, .ypColorSelection18
    ]
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                                   "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let header: UILabel = {
        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        header.textColor = UIColor(named: "YP Black (day)")
        return header
    }()
    
    private let habitTextField: UITextField = {
        let habitTextField = UITextField()
        habitTextField.translatesAutoresizingMaskIntoConstraints = false
        habitTextField.layer.masksToBounds = true
        habitTextField.layer.cornerRadius = 16
        habitTextField.backgroundColor = UIColor(named: "YP Background (day)")
        habitTextField.textColor = UIColor(named: "YP Black (day)")
        habitTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: habitTextField.frame.height))
        habitTextField.leftViewMode = .always
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "YP Gray") as Any]
        habitTextField.attributedPlaceholder = NSAttributedString(string: "Введите название трекера", attributes: attributes)
        
        return habitTextField
    }()
    
    private let habitTableView: UITableView = {
        let habitTableView = UITableView()
        habitTableView.translatesAutoresizingMaskIntoConstraints = false
        habitTableView.backgroundColor = UIColor(named: "YP White (day)")
        
        return habitTableView
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
    
    private let createHabitButton: UIButton = {
        let createHabitButton = UIButton()
        createHabitButton.translatesAutoresizingMaskIntoConstraints = false
        createHabitButton.setTitle("Создать", for: .normal)
        createHabitButton.setTitleColor(UIColor(named: "YP White (day)"), for: .normal)
        createHabitButton.backgroundColor = UIColor(named: "YP Gray")
        createHabitButton.layer.cornerRadius = 16
        createHabitButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        createHabitButton.isEnabled = false
        createHabitButton.addTarget(nil, action: #selector(createHabitButtonTapped), for: .touchUpInside)
        
        return createHabitButton
    }()
    
    private let emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitEmojiCell.self, forCellWithReuseIdentifier: "HabitEmojiCell")
        collectionView.register(HabitEmojiHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HabitEmojiHeader.id)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HabitColorCell.self, forCellWithReuseIdentifier: "HabitColorCell")
        collectionView.register(HabitColorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HabitColorHeader.id)
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    private var category: String?
    private var chosenDays: [Int] = []
    private var categoryIndex: Int?
    
    // MARK: - Methods
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createHabitButtonTapped() {
        guard let text: String = habitTextField.text,
              let category: String = category,
              let emoji = selectedEmoji,
              let color = selectedColor
        else { return }
                if let delegate = delegate {
                    delegate.addNewHabit(TrackerCategory(header: category, trackersArray: [Tracker(id: UUID(), name: text, color: color, emoji: emoji, schedule: chosenDays)]))
        } else { return }
        dismiss(animated: true)
    }
    
    private func setupEmojiCollectionView() {
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupColorCollectionView() {
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureHabitLayout() {
        view.backgroundColor = UIColor(named: "YP White (day)")
        view.addSubview(scrollView)
        scrollView.addSubview(header)
        scrollView.addSubview(habitTextField)
        scrollView.addSubview(habitTableView)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        scrollView.addSubview(createHabitButton)
        scrollView.addSubview(cancelButton)
        
        navigationItem.title = "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YP Black (day)")]
        navigationItem.hidesBackButton = true
        
        habitTableView.delegate = self
        habitTableView.dataSource = self
        habitTableView.register(HabitCell.self, forCellReuseIdentifier: HabitCell.reuseIdentifier)
        habitTableView.separatorColor = UIColor(named: "YP Gray")
        habitTableView.separatorStyle = .singleLine
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            header.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 26),
            header.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            header.heightAnchor.constraint(equalToConstant: 22),
            habitTextField.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            habitTextField.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            habitTextField.heightAnchor.constraint(equalToConstant: 75),
            habitTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            habitTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            habitTableView.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 24),
            habitTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            habitTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            habitTableView.heightAnchor.constraint(equalToConstant: 149),
            emojiCollectionView.topAnchor.constraint(equalTo: habitTableView.bottomAnchor, constant: 32),
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
            createHabitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            createHabitButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            createHabitButton.heightAnchor.constraint(equalToConstant: 60),
            createHabitButton.leadingAnchor.constraint(equalTo: colorCollectionView.centerXAnchor, constant: 4)
        ])
    }
    
    private func checkButtonAccessibility() {
        if let text = habitTextField.text,
           !text.isEmpty,
           category != nil,
           selectedColor != nil,
           selectedEmoji != nil,
           !chosenDays.isEmpty {
              createHabitButton.isEnabled = true
              createHabitButton.backgroundColor = UIColor(named: "YP Black (day)")
               createHabitButton.setTitleColor(UIColor(named: "YP White (day)"), for: .normal)
           } else {
               createHabitButton.isEnabled = false
               createHabitButton.backgroundColor = UIColor(named: "YP Gray")
           }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHabitLayout()
        setupColorCollectionView()
        setupEmojiCollectionView()
    }
}

// MARK: - Extensions

extension HabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoryVC = CategoryViewController(chosenCategoryIndex: categoryIndex)
            categoryVC.delegate = self
            navigationController?.pushViewController(categoryVC, animated: true)
        } else if indexPath.row == 1 {
            let scheduleVC = ScheduleViewController(chosedDays: chosenDays)
            scheduleVC.delegate = self
            navigationController?.pushViewController(scheduleVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension HabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitCell.reuseIdentifier, for: indexPath) as! HabitCell
        cell.backgroundColor = UIColor(named: "YP Background (day)")
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категория"
            cell.textLabel?.textColor = UIColor(named: "YP Black (day)")
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        } else {
            cell.textLabel?.text = "Расписание"
            cell.textLabel?.textColor = UIColor(named: "YP Black (day)")
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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

extension HabitViewController: CategoryViewControllerDelegate {
    func addCategory(_ category: String, index: Int) {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = habitTableView.cellForRow(at: indexPath) as? HabitCell {
            cell.detailTextLabel?.text = category
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            cell.detailTextLabel?.textColor = UIColor(named: "YP Gray")
        }
        self.category = category
        categoryIndex = index
        checkButtonAccessibility()
    }
}

extension HabitViewController: ScheduleViewControllerDelegate {
    func addWeekDays(_ weekdays: [Int]) {
        chosenDays = weekdays
        var daysView = ""
        if weekdays.count == 7 {
            daysView = "Каждый день"
        } else {
            for index in chosenDays {
                var calendar = Calendar.current
                calendar.locale = Locale(identifier: "ru_RU")
                let day = calendar.shortWeekdaySymbols[index]
                daysView.append(day)
                daysView.append(", ")
            }
            daysView = String(daysView.dropLast(2))
        }
        let indexPath = IndexPath(row: 1, section: 0)
        if let cell = habitTableView.cellForRow(at: indexPath) as? HabitCell {
            cell.detailTextLabel?.text = daysView
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            cell.detailTextLabel?.textColor = UIColor(named: "YP Gray")
        }
        checkButtonAccessibility()
    }
}

extension HabitViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitEmojiCell", for: indexPath) as? HabitEmojiCell else {
                return UICollectionViewCell()
            }
            let emojiIndex = indexPath.item % emoji.count
            let selectedEmoji = emoji[emojiIndex]
            
            cell.emojiLabel.text = selectedEmoji
            cell.layer.cornerRadius = 16
            
            return cell
        } else if collectionView == colorCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitColorCell", for: indexPath) as? HabitColorCell else {
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
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HabitEmojiHeader.id, for: indexPath) as? HabitEmojiHeader else {
                return UICollectionReusableView()
            }
            header.headerText = "Emoji"
            return header
        } else if collectionView == colorCollectionView {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HabitColorHeader.id, for: indexPath) as? HabitColorHeader else {
                return UICollectionReusableView()
            }
            header.headerText = "Цвет"
            return header
        }
        
        return UICollectionReusableView()
    }
}

extension HabitViewController: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == emojiCollectionView {
//            let cell = collectionView.cellForItem(at: indexPath) as? HabitEmojiCell
//            cell?.backgroundColor = UIColor(named: "YP Light Gray")
//            
//            selectedEmoji = cell?.emojiLabel.text
//        } else if collectionView == colorCollectionView {
//            let cell = collectionView.cellForItem(at: indexPath) as? HabitColorCell
//            cell?.layer.borderWidth = 3
//            cell?.layer.borderColor = cell?.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
//            
//            selectedColor = cell?.colorView.backgroundColor
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? HabitEmojiCell
            cell?.backgroundColor = UIColor(named: "YP Light Gray")
            
            selectedEmoji = cell?.emojiLabel.text
        } else { }
           if collectionView == colorCollectionView {
                let cell = collectionView.cellForItem(at: indexPath) as? HabitColorCell
                cell?.layer.borderWidth = 3
                cell?.layer.borderColor = cell?.colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
                
                selectedColor = cell?.colorView.backgroundColor
           } else { 
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? HabitEmojiCell
            cell?.backgroundColor = UIColor(named: "YP White (day)")
        } else if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? HabitColorCell
            cell?.layer.borderWidth = 0
        }
    }
}
