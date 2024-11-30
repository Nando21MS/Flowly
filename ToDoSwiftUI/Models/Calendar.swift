//
//  Calendar.swift
//  ToDoSwiftUI
//
//  Created by DAMII on 30/11/24.
//

import Foundation
import CoreData
class Calendar: NSManagedObject, Identifiable {
    @NSManaged var title: String?
    @NSManaged var reminderDate: Date?
    @NSManaged var details: String?
    
    static func fetchAllTaskRequest() -> NSFetchRequest<Calendar> {
        return NSFetchRequest<Calendar>(entityName: "Calendar")
    }
}
