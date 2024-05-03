//
//  SwitchCell.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 30.04.2024.
//

import UIKit

protocol SwitchCellDelegate: AnyObject {
    func switchCellDidToggle(_ cell: SwitchCell, isOn: Bool)
}

final class SwitchCell: UITableViewCell {
    
    static let reuseIdentifier = "SwitchCell"
    weak  var delegate: SwitchCellDelegate?
    
    let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.tintColor = UIColor(named: "YP White (day)")
        switcher.onTintColor = UIColor(named: "YP Blue")
        
        return switcher
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        selectionStyle = .none
        
        switcher.addTarget(self, action: #selector(switcherValueChanged), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupLayout() {
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        textLabel?.textColor = UIColor(named: "YP Black (day)")
        contentView.addSubview(switcher)
        
        NSLayoutConstraint.activate([
            switcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func switcherValueChanged(_ sender: UISwitch) {
        delegate?.switchCellDidToggle(self, isOn: sender.isOn)
    }
}
