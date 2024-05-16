//
//  TrackerStore.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 10.05.2024.
//

import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func store() -> Void
}

final class TrackerStore: NSObject {
    
    private let uiColorMarshalling = UIColorMarshalling()
     var context: NSManagedObjectContext
    private var fetchedResultController: NSFetchedResultsController<TrackerCoreData>!
    
    weak var delegate: TrackerStoreDelegate?
    
    var trackers: [Tracker] {
        get {
            guard let objects = self.fetchedResultController.fetchedObjects,
                  let trackers = try? objects.map({ try self.tracker(from: $0) })
            else { return [] }
            return trackers
        }
        set {
        }
    }

    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).context
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetch = TrackerCoreData.fetchRequest()
        fetch.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetch,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultController = controller
        try controller.performFetch()
    }
    
    func addNewTracker(_ tracker: Tracker) throws {
        if tracker.schedule == nil {
            // Нерегулярное событие
                  let trackerCoreData = TrackerCoreData(context: context)
                  trackerCoreData.id = tracker.id
                  trackerCoreData.name = tracker.name
                  trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
                  trackerCoreData.emoji = tracker.emoji
                  try context.save()        } else {
            // Регулярный трекер
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.name = tracker.name
            trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = tracker.schedule?.map { $0 }
            try context.save()
        }
    }

    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id,
              let emoji = trackerCoreData.emoji,
              let color = uiColorMarshalling.color(from: trackerCoreData.color ?? ""),
              let name = trackerCoreData.name,
              let schedule = trackerCoreData.schedule
        else {
            fatalError()
        }
        return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule.map({ $0 }))
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения контекста Core Data: \(error)")
        }
    }

    func loadTrackers() {
        
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        
        do {
            let fetchedTrackers = try context.fetch(fetchRequest)
            
            var trackers: [Tracker] = []
            
            for trackerCoreData in fetchedTrackers {
                guard let id = trackerCoreData.id,
                      let name = trackerCoreData.name,
                      let emoji = trackerCoreData.emoji,
                      let color = uiColorMarshalling.color(from: trackerCoreData.color ?? "")
                else {
                    continue
                }
                
                let tracker = Tracker(id: id, name: name, color: color, emoji: emoji, schedule: trackerCoreData.schedule?.map({ $0 }))
                
                trackers.append(tracker)
            }
            self.trackers = trackers
            delegate?.store()
        } catch {
            print("Ошибка при загрузке трекеров из CoreData: \(error)")
        }
    }

}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store()
    }
}
