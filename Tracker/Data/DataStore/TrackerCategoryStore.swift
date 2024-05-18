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
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    private let uiColorMarshalling = UIColorMarshalling()
    private let trackerStore = TrackerStore()
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    var trackerCategories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({ try self.trackerCategory(from: $0) })
        else { return [] }
        return categories
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).context
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetch = TrackerCategoryCoreData.fetchRequest()
        fetch.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.header, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    func addNewCategory(_ category: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.header = category.header
        trackerCategoryCoreData.trackerArray = category.trackersArray.map {
            $0.id
        }
        try context.save()
    }
    
    func addTrackerToCategory(to header: String?, tracker: Tracker) throws {
        guard let fromDb = try self.fetchTrackerCategory(with: header) else { fatalError() }
        fromDb.trackerArray = trackerCategories.first {
            $0.header == header
        }?.trackersArray.map { $0.id }
        print(type(of: fromDb.tracker))
        
        fromDb.trackerArray?.append(tracker.id)
        try context.save()
    }
    
    func fetchTrackerCategory(with header: String?) throws -> TrackerCategoryCoreData? {
        guard let header = header else { fatalError() }
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "header == %@", header as CVarArg)
        let result = try context.fetch(fetchRequest)
        return result.first
    }
    
    func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let header = trackerCategoryCoreData.header,
              let trackers = trackerCategoryCoreData.trackerArray
        else {
            fatalError()
        }
        return TrackerCategory(header: header, trackersArray: trackerStore.trackers.filter { trackers.contains($0.id) })
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeCategory()
    }
}
