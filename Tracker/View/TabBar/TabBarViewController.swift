//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 30.04.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTabBarViewController()
    }
    
    private func makeTabBarViewController() {
        tabBar.backgroundColor = UIColor(named: "YP White (day)")
        tabBar.tintColor = UIColor(named: "YP Blue")
        tabBar.barTintColor = UIColor(named: "YP Blue")
        tabBar.isTranslucent = true
        tabBar.clipsToBounds = true
        
        let trackersVC = TrackersViewController()
        let trackersNavigationController = UINavigationController(rootViewController: trackersVC)
        
        
    }
}
