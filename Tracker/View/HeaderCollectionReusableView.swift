//
//  HeaderCollectionReusableView.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 30.04.2024.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "YP Black (day)")
        label.font = .boldSystemFont(ofSize: 19)
        
        return label
    }()
    
    func configureHeader(text: String) {
        headerLabel.text = text
        
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
