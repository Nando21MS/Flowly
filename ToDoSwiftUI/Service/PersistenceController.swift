//
//  PersistenceController.swift
//  ToDoSwiftUI
//
//  Created by DAMII on 15/10/24.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController() 
  let container: NSPersistentContainer

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "ToDoSwiftUIModel")

    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }

    container.loadPersistentStores { description, error in
      if let error = error {
        fatalError("Error loading Core Data stores: \(error)")
      }
    }
  }
}
