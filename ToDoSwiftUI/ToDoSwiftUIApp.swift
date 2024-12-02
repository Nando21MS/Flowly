//
//  ToDoSwiftUIApp.swift6//  ToDoSwiftUI
//
//  Created by DAMII on 15/10/24.
//

import SwiftUI
import CoreData
import UserNotifications

@main
struct ToDoSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TaskListView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notifications permission: \(error)")
            } else if granted {
                print("Notification permissions granted!")
            } else {
                print("Notification permissions denied.")
            }
        }
    }
}
