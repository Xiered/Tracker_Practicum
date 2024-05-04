//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 02.05.2024.
//

import UIKit

protocol TrackerViewDelegate: AnyObject {
    func dayCheckButtonTapped(viewModel: CellModel)
}

final class TrackerViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    weak var delegate: TrackerViewDelegate?
    private var viewModel: CellModel?
    
    // Substrate with color
    private let cardBackground: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.masksToBounds = true
        cardView.layer.cornerRadius = 16
        return cardView
    }()
    // Emoji
    private let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.layer.masksToBounds = true
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        return emojiLabel
    }()
    // Task label
    private let taskLabel: UILabel = {
        let taskLabel = UILabel()
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.textColor = UIColor(named: "YP White (day)")
        taskLabel.font = UIFont.systemFont(ofSize: 12)
        return taskLabel
    }()
    // Label with day count
    private let dayCountLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textColor = UIColor(named: "YP Black (day)")
        dayLabel.font = UIFont.systemFont(ofSize: 12)
        return dayLabel
    }()
    // Approve button
    private let checkButton: UIButton = {
        let checkButton = UIButton()
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.tintColor = UIColor(named: "YP White (day)")
        checkButton.backgroundColor = UIColor(named: "Color selection 5")
        checkButton.layer.masksToBounds = true
        checkButton.layer.cornerRadius = 16
        checkButton.imageView?.contentMode = .scaleAspectFill
        // addTarget
        return checkButton
    }()
    
    private let dayCheckButton: UIButton = {
        let dayCheckButton = UIButton()
        dayCheckButton.translatesAutoresizingMaskIntoConstraints = false
        dayCheckButton.layer.masksToBounds = false
        dayCheckButton.layer.cornerRadius = 16
        dayCheckButton.setTitle("", for: .normal)
        dayCheckButton.tintColor = UIColor(named: "YP White (day)")
        dayCheckButton.backgroundColor = UIColor(named: "Color selection 5")
        dayCheckButton.imageView?.contentMode = .scaleAspectFill
        dayCheckButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        dayCheckButton.addTarget(nil, action: #selector(dayCheckButtonTapped(_:)), for: .touchUpInside)
        
        return dayCheckButton
    }()

    // MARK: - Methods
    
    private func dayDeclension(for counter: Int) -> String {
        let remain = counter % 10
        if counter == 11 || counter == 12 || counter == 13 || counter == 14 {
            return "дней"
        }
        switch remain {
        case 1: return "день"
        case 2, 3, 4: return "дня"
        default: return "дней"
        }
    }
    
    func configureCell(viewModel: CellModel) {
        taskLabel.text = viewModel.tracker.name
        emojiLabel.text = viewModel.tracker.emoji
        cardBackground.backgroundColor = viewModel.tracker.color
        dayCountLabel.text = "\(viewModel.dayCount) \(dayDeclension(for: viewModel.dayCount))"
    
        self.viewModel = viewModel
        
        dayCheckButtonState()
        dayCheckButtonIsEnabled()
        configureCustomCell()
    }
    
    private func configureCustomCell() {
        addSubview(cardBackground)
        addSubview(dayCountLabel)
        addSubview(dayCheckButton)
        cardBackground.addSubview(emojiLabel)
        cardBackground.addSubview(taskLabel)
        
        NSLayoutConstraint.activate([
            
            cardBackground.topAnchor.constraint(equalTo: topAnchor),
            cardBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardBackground.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            taskLabel.bottomAnchor.constraint(equalTo: cardBackground.bottomAnchor, constant: -12),
            taskLabel.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 12),
            taskLabel.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -12),
          
            dayCheckButton.topAnchor.constraint(equalTo: cardBackground.bottomAnchor, constant: 8),
            dayCheckButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            dayCheckButton.heightAnchor.constraint(equalToConstant: 34),
            dayCheckButton.widthAnchor.constraint(equalToConstant: 34),
            
            dayCountLabel.centerYAnchor.constraint(equalTo: dayCheckButton.centerYAnchor),
            dayCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
        
        dayCheckButtonState()
    }
    
    // Updates the state button of checkButton depending on the value of the buttonIsChecked (from CellModel) property
    private func dayCheckButtonState() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
        var symbolImage: UIImage?
        guard let viewModel = viewModel else { return }
        if viewModel.buttonIsChecked {
           symbolImage = UIImage(systemName: "checkmark", withConfiguration: symbolConfig)
            dayCheckButton.layer.opacity = 0.3
        } else {
            //symbolImage = UIImage(systemName: "plusButtonImage", withConfiguration: symbolConfig)
            symbolImage = UIImage(named: "trackerPlus")
            dayCheckButton.layer.opacity = 1.0
        }
        dayCheckButton.setImage(symbolImage, for: .normal)
    }
    
    // Checking and updating the state of a checkButton depending on the value of the buttonIsEnabled property
    private func dayCheckButtonIsEnabled() {
        guard let viewModel = viewModel,
              let selectedDate = TrackersViewController.selectedDate else { return }
        let currentDate = Date()
        let calendar = Calendar.current
        let isButtonEnabled = calendar.compare(currentDate, to: selectedDate, toGranularity: .day) != .orderedAscending

        if viewModel.buttonIsEnabled && isButtonEnabled {
            dayCheckButton.isEnabled = true
            dayCheckButton.backgroundColor = viewModel.tracker.color.withAlphaComponent(1)
        } else {
            dayCheckButton.isEnabled = false
            dayCheckButton.backgroundColor = viewModel.tracker.color.withAlphaComponent(0.3)
        }
    }
    
    @objc private func dayCheckButtonTapped(_ sender: UIButton) {
        viewModel?.buttonIsChecked.toggle()
        dayCheckButtonState()
        guard let viewModel = viewModel else { return }
        delegate?.dayCheckButtonTapped(viewModel: viewModel)
    }
}
