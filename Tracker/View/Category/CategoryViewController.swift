//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 02.05.2024.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func addCategory(_ category: String, index: Int)
}

final class CategoryViewController: UIViewController {
    
    // MARK: - Variables
    
    weak var delegate: CategoryViewControllerDelegate?
    
    private var categoryTableView: UITableView = {
        let categoryTableView = UITableView()
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        categoryTableView.backgroundColor = UIColor(named: "YP White (day)")
        
        return categoryTableView
    }()
    
    private let imagePlaceholder: UIImageView = {
        let imagePlaceholder = UIImageView()
        imagePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        imagePlaceholder.image = UIImage(named: "trackersPlaceholder")
        imagePlaceholder.isHidden = false
        
        return imagePlaceholder
    }()
    
    private let textPlaceholder: UILabel = {
        let textPlaceholder = UILabel()
        textPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        textPlaceholder.text = """
                                Привычки и события можно
                                объединить по смыслу
                                """
        textPlaceholder.textAlignment = .center
        textPlaceholder.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textPlaceholder.textColor = UIColor(named: "YP Black (day)")
        textPlaceholder.isHidden = false
        textPlaceholder.numberOfLines = 2
        
        return textPlaceholder
    }()
    
    private let addCategoryButton: UIButton = {
        let addCategoryButton = UIButton()
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(UIColor(named: "YP White (day)"), for: .normal)
        addCategoryButton.backgroundColor = UIColor(named: "YP Black (day)")
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        addCategoryButton.addTarget(nil, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return addCategoryButton
    }()
    
    private var categoryArray: [String] = ["Важное"]
    private var chosenCategoryIndex: Int?
    private var categoryTableViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Methods
    
    init(chosenCategoryIndex: Int?) {
        super.init(nibName: nil, bundle: nil)
        self.chosenCategoryIndex = chosenCategoryIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func configureCategoryLayout() {
        view.backgroundColor = UIColor(named: "YP White (day)")
        
        navigationItem.title = "Категория"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YP Black (day)")]
        navigationItem.hidesBackButton = true
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        categoryTableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        categoryTableView.separatorColor = UIColor(named: "YP Gray")
        categoryTableView.separatorStyle = .singleLine
        categoryTableViewHeightConstraint = categoryTableView.heightAnchor.constraint(equalToConstant: CGFloat(categoryArray.count * 75))
        categoryTableViewHeightConstraint?.isActive = true
        
        view.addSubview(categoryTableView)
        view.addSubview(imagePlaceholder)
        view.addSubview(textPlaceholder)
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
           
            imagePlaceholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imagePlaceholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textPlaceholder.centerXAnchor.constraint(equalTo: imagePlaceholder.centerXAnchor),
            textPlaceholder.topAnchor.constraint(equalTo: imagePlaceholder.bottomAnchor, constant: 8),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func hidePlaceholders() {
        if categoryArray.count != 0 {
            textPlaceholder.isHidden = true
            imagePlaceholder.isHidden = true
        }
    }
    
    private func updateCategoryTableViewHeight() {
        categoryTableViewHeightConstraint?.constant = CGFloat(categoryArray.count * 75)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCategoryLayout()
        hidePlaceholders()
    }
    
    @objc private func addCategoryButtonTapped() {
        let newCategoryVC = NewCategoryViewController()
        newCategoryVC.delegate = self
        navigationController?.pushViewController(newCategoryVC, animated: true)
    }

}

// MARK: - Extensions

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTitle = categoryArray[indexPath.row]
        delegate?.addCategory(selectedTitle, index: chosenCategoryIndex ?? 1)
        navigationController?.popViewController(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        cell.backgroundColor = UIColor(named: "YP Background (day)")
        cell.textLabel?.text =  categoryArray[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        // Delimiter
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))
        
        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.row == lastRowIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        }
        
        if let categoryCell = cell as? CategoryCell {
            if categoryArray.count == 1 {
                categoryCell.layer.cornerRadius = 16
                categoryCell.clipsToBounds = true
                categoryCell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            } else if indexPath.row == 0 {
                categoryCell.layer.cornerRadius = 16
                categoryCell.clipsToBounds = true
                categoryCell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == numberOfRows - 1 {
                categoryCell.layer.cornerRadius = 16
                categoryCell.clipsToBounds = true
                categoryCell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                categoryCell.layer.cornerRadius = 0
            }
        }
    }
}

extension CategoryViewController: NewCategoryViewControllerDelegate {
    func didAddCategory(category: String) {
        categoryArray.append(category)
        updateCategoryTableViewHeight()
        categoryTableView.reloadData()
        hidePlaceholders()
    }
}
