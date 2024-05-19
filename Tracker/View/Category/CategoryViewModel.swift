//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 18.05.2024.
//

import UIKit

class CategoryViewModel: TrackerCategoryStoreDelegate {

    private var categories: [TrackerCategoryCoreData] = []
    
    init() {
        TrackerCategoryStore.shared.delegate = self
    }
    
    func fetchCategories() {
        categories = TrackerCategoryStore.shared.trackerCategories
    }
    
    func addCategory(_ category: String) {
        TrackerCategoryStore.shared.addNewCategory(category)
    }
    
    func storeCategory() {
        fetchCategories()
    }
}

