//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 02.05.2024.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func addWeekDays(_ weekdays: [Int])
}

final class ScheduleViewController: UIViewController {
    
    // MARK: - Variables
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private let weekdayTable: UITableView = {
        let weekdayTable = UITableView()
        weekdayTable.translatesAutoresizingMaskIntoConstraints = false
        weekdayTable.backgroundColor = UIColor(named: "YP White (day)")
        weekdayTable.isScrollEnabled = false
        
        return weekdayTable
    }()
    
    private let okayButton: UIButton = {
        let okayButton = UIButton()
        okayButton.translatesAutoresizingMaskIntoConstraints = false
        okayButton.setTitle("Готово", for: .normal)
        okayButton.backgroundColor = UIColor(named: "YP Black (day)")
        okayButton.setTitleColor(UIColor(named: "YP White (day)"), for: .normal)
        okayButton.layer.cornerRadius = 16
        okayButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        okayButton.addTarget(nil, action: #selector(okayButtonTapped), for: .touchUpInside)
        
        return okayButton
    }()
    
    private var calendar = Calendar.current
    private var days = [String]()
    private var finalList: [Int] = []
    private var switchStates: [Int : Bool] = [:]
    
    // MARK: - Methods
    
    init(chosedDays: [Int]) {
        super.init(nibName: nil, bundle: nil)
        calendar.locale = Locale(identifier: "ru_RU")
        days = calendar.weekdaySymbols
        finalList = chosedDays
        setupInitialSelectedDays()
        print(switchStates)
        print(finalList)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    @objc private func okayButtonTapped() {
        finalList.removeAll()

        let tableView = weekdayTable
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? SwitchCell else { continue }
                guard cell.switcher.isOn else { continue }
                guard let text = cell.textLabel?.text else { continue }
                guard let weekday = getIndexOfWeek(text) else { continue }
                finalList.append(weekday)
            }
        }
        delegate?.addWeekDays(finalList)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupInitialSelectedDays() {
        for (index, day) in days.enumerated() {
            let weekdayIndex = calendar.weekdaySymbols.firstIndex(of: day.lowercased()) ?? 0

            if finalList.contains(weekdayIndex + 1) {
                switchStates[index] = true
            } else {
                switchStates[index] = false
            }
        }
    }
    
    private func getIndexOfWeek(_ text: String) -> Int? {
        return calendar.weekdaySymbols.firstIndex(of: text.lowercased())
    }
    
    private func setupScheduleLayout() {
        view.backgroundColor = UIColor(named: "YP White (day)")
        navigationItem.title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YP Black (day)") ?? UIColor.black]
        navigationItem.hidesBackButton = true

        weekdayTable.dataSource = self
        weekdayTable.delegate = self
        weekdayTable.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.reuseIdentifier)
        weekdayTable.separatorStyle = .singleLine
        weekdayTable.separatorColor = UIColor(named: "YP Gray")
        
        view.addSubview(weekdayTable)
        view.addSubview(okayButton)

        NSLayoutConstraint.activate([
            weekdayTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            weekdayTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekdayTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekdayTable.heightAnchor.constraint(equalToConstant: 7 * 75),
            okayButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            okayButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            okayButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            okayButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            okayButton.heightAnchor.constraint(equalToConstant: 60)


        ])
    }
    
    private func configDaysArray() {
        let weekdaySymbols = calendar.weekdaySymbols
        let firstDayIndex = 1
        
        let weekdays = Array(weekdaySymbols[firstDayIndex...]) + Array(weekdaySymbols[..<firstDayIndex])
        days = weekdays.map { $0.capitalizeFirstLetter() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScheduleLayout()
        configDaysArray()
        weekdayTable.reloadData()
    }
    
}

// MARK: - Extensions

extension ScheduleViewController: SwitchCellDelegate {
    func switchCellDidToggle(_ cell: SwitchCell, isOn: Bool) {
        if let indexPath = weekdayTable.indexPath(for: cell) {
            // Save the switch state value in the dictionary
            switchStates[indexPath.row] = isOn
        }
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.reuseIdentifier, for: indexPath) as! SwitchCell
        cell.backgroundColor = UIColor(named: "YP Background")
        cell.textLabel?.text = days[indexPath.row]
        
        // Get the switch state value from the dictionary
        let switchState = switchStates[indexPath.row] ?? false
        
        // Set the switch state value
        cell.switcher.isOn = switchState
        
        // Add a target for the switch value change event
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numbersOfRows = tableView.numberOfRows(inSection: 0)

        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == numbersOfRows - 1 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))

        let lastRowIndex = numbersOfRows - 1
        if indexPath.row == lastRowIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        }
    }
}
