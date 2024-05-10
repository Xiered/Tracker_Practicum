//
//  HabitOrIrregularViewController.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 21.01.2024.
//

import UIKit

// Controller for choosing habbit or irregular event
final class HabitOrIrregularViewController: UIViewController {
    
    // MARK: - Variables
    
    private let habitButton: UIButton = {
        let habitButton = UIButton()
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.setTitleColor((UIColor(named: "YP White (day)")), for: .normal)
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.backgroundColor = UIColor(named: "YP Black (day)")
        habitButton.layer.cornerRadius = 16
        habitButton.layer.masksToBounds = true
        habitButton.imageView?.contentMode = .scaleAspectFit
        habitButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        habitButton.addTarget(nil, action: #selector(habitButtonTapped), for: .touchUpInside)
        
        return habitButton
    }()
    
    private let irregularButton: UIButton = {
        let irregularButton = UIButton()
        irregularButton.translatesAutoresizingMaskIntoConstraints = false
        irregularButton.setTitle("Нерегулярное событие", for: .normal)
        irregularButton.setTitleColor(UIColor(named: "YP White (day)"), for: .normal)
        irregularButton.backgroundColor = UIColor(named: "YP Black (day)")
        irregularButton.layer.masksToBounds = true
        irregularButton.layer.cornerRadius = 16
        irregularButton.imageView?.contentMode = .scaleAspectFill
        irregularButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        irregularButton.addTarget(nil, action: #selector(irregularButtonTapped), for: .touchUpInside)
        
        return irregularButton
    }()
    
    private var newHabitViewController: UIViewController?
    private var newIrregularEventViewController: UIViewController?
    // MARK: - Methods
    
    init(newHabitViewController: UIViewController?, newIrregularEventViewController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        self.newHabitViewController = newHabitViewController
        self.newIrregularEventViewController = newIrregularEventViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    @objc func habitButtonTapped() {
        guard let newHabitViewController else { return }
        navigationController?.pushViewController(newHabitViewController, animated: true)
    }
    
    @objc func irregularButtonTapped() {
        guard let newIrregularEventViewController else { return }
        navigationController?.pushViewController(newIrregularEventViewController, animated: true)
    }
    
    private func setupLayout() {
        navigationItem.title = "Создание Трекера"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YP Black (day)")]
        
        view.addSubview(habitButton)
        view.addSubview(irregularButton)
        
        NSLayoutConstraint.activate([
            habitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 281),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),

            irregularButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            irregularButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            irregularButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            irregularButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP White (day)")
        setupLayout()
    }
}
