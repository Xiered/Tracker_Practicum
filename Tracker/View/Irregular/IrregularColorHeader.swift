//
//  IrregularColorHeader.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 10.05.2024.
//

import UIKit

final class IrregularColorHeader: UICollectionReusableView {
    
    static let id = "header"
    var headerText: String? {
        didSet {
            titleLabel.text = headerText
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "YP Black (day)")
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
