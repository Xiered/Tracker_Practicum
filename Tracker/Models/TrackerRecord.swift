//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Дмитрий Герасимов on 30.04.2024.
//

import UIKit

struct TrackerRecord {
    let id: UUID
    let date: String
}

extension TrackerRecord: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
