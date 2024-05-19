//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 10.05.2024.
//

import CoreData
import UIKit

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeCategory() -> Void
}

final class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    
    private var context: NSManagedObjectContext
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var trackerCategories: [TrackerCategoryCoreData] {
        do {
            return try context.fetch(TrackerCategoryCoreData.fetchRequest())
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainter.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    func addNewCategory(_ category: String) {
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.header = category
        do {
            try context.save()
            delegate?.storeCategory()
        } catch {
            print("Failed to save new category: \(error)")
        }
    }
    
    func addTrackerToCategory(to header: String?, tracker: Tracker) {
      
    }
}
