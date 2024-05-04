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
    
    private let habitTextField: UITextField = {
        let habitTextField = UITextField()
        habitTextField.translatesAutoresizingMaskIntoConstraints = false
        habitTextField.layer.masksToBounds = true
        habitTextField.layer.cornerRadius = 16
        habitTextField.backgroundColor = UIColor(named: "YP Background (day)")
        habitTextField.textColor = UIColor(named: "YP Black (day)")
        
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
    
    private var category: String?
    private var chosenDays: [Int] = []
    private var categoryIndex: Int?
    
    // MARK: - Methods
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createHabitButtonTapped() {
        let text: String = habitTextField.text ?? ""
        let category: String = category ?? ""
     /*   if let delegate = delegate {
            delegate.addNewHabit(TrackerCategory(header: category, trackersArray: [Tracker(id: UUID(), name: text, color: UIColor(named: "Color selection 5") ?? .green, emoji: "🩷", schedule: chosenDays)]))
        } */
        let newTracker = Tracker(id: UUID(), name: text, color: UIColor(named: "Color selection 8") ?? .red, emoji: "🩷", schedule: chosenDays)
        trackersVC?.appendTracker(tracker: newTracker)
        trackersVC?.reload()
     //   self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
     /*   guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = TabBarViewController()
        window.rootViewController = tabBarController */
    }
    
    private func configureHabitLayout() {
        view.backgroundColor = UIColor(named: "YP White (day)")
        view.addSubview(habitTableView)
        view.addSubview(habitTextField)
        view.addSubview(cancelButton)
        view.addSubview(createHabitButton)
        
        navigationItem.title = "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YP Black (day)") ?? .green]
        navigationItem.hidesBackButton = true
        
        habitTableView.delegate = self
        habitTableView.dataSource = self
        habitTableView.register(HabitCell.self, forCellReuseIdentifier: HabitCell.reuseIdentifier)
        habitTableView.separatorColor = UIColor(named: "YP Gray")
        habitTableView.separatorStyle = .singleLine
        
        NSLayoutConstraint.activate([
            
            habitTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            habitTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            habitTextField.heightAnchor.constraint(equalToConstant: 75),
            
            habitTableView.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 24),
            habitTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            habitTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitTableView.heightAnchor.constraint(equalToConstant: 2 * 75),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createHabitButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createHabitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func checkButtonAccessibility() {
        if let text = habitTextField.text,
           !text.isEmpty,
           category != nil,
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
        }
        checkButtonAccessibility()
    }
}
