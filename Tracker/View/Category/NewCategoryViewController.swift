//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 02.05.2024.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func didAddCategory(category: String)
}

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Variables
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
    private let newCategoryTextField: UITextField = {
        let newCategoryTextField = UITextField()
        newCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        newCategoryTextField.backgroundColor = UIColor(named: "YP Background (day)")
        newCategoryTextField.textColor = UIColor(named: "YP Black (day)")
        newCategoryTextField.clearButtonMode = .whileEditing
        newCategoryTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: newCategoryTextField.frame.height))
        newCategoryTextField.leftViewMode = .always
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "YP Gray") as Any]
        newCategoryTextField.attributedPlaceholder = NSAttributedString(string: "Название категории (не менее 3 символов)", attributes: attributes)
        newCategoryTextField.layer.masksToBounds = true
        newCategoryTextField.layer.cornerRadius = 16
        
        return newCategoryTextField
    }()
    
    private let readyButton: UIButton = {
        let readyButton = UIButton()
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.setTitle("Готово", for: .normal)
        readyButton.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        readyButton.layer.cornerRadius = 16
        readyButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        readyButton.addTarget(nil, action: #selector(readyButtonTapped), for: .touchUpInside)
        
        return readyButton
    }()
    
    // MARK: - Methods
    
    private func configureNewCategoryLayout() {
        navigationItem.title = "Новая категория"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YP Black (day)") ?? UIColor(named: "YP Black (day)")]
        navigationItem.hidesBackButton = true
        
        view.addSubview(newCategoryTextField)
        view.addSubview(readyButton)
        view.backgroundColor = UIColor(named: "YP White (day)")
        
        NSLayoutConstraint.activate([
            
            newCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            newCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
        
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func readyButtonTapped() {
        guard let category = newCategoryTextField.text else { return }
        delegate?.didAddCategory(category: category)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newCategoryTextField.delegate = self
        readyButton.isEnabled = true
        readyButton.backgroundColor = UIColor(named: "YP Gray")
        configureNewCategoryLayout()
    }
    
}

// MARK: - Extensions

extension NewCategoryViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text,
           text.count >= 3 {
            readyButton.isEnabled = true
            readyButton.backgroundColor = UIColor(named: "YP Black (day)")
            readyButton.setTitleColor(UIColor(named: "YP White (day)"), for: .normal)
        } else {
            readyButton.isEnabled = false
            readyButton.backgroundColor = UIColor(named: "YP Gray")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
