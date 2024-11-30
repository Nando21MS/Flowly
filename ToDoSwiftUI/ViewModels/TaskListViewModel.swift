//
//  TaskListViewModel.swift
//  ToDoSwiftUI
//
//  Created by DAMII on 22/10/24.
//

import Foundation
import CoreData
import UserNotifications // Importa el framework de notificaciones

class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    private var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    init() {
        self.fetchAllTasks()
    }
    
    func addTask(title: String, details: String? = nil, reminderDate: Date? = nil, priority: String, category: String) {
        let task = Task(context: context)
        task.title = title
        task.details = details
        task.reminderDate = reminderDate
        task.priority = priority
        task.category = category
        saveContext()
        fetchAllTasks()
        
        // Programa un recordatorio si se estableció una fecha
        if let reminderDate = reminderDate {
            scheduleReminder(for: task)
        }
    }
    
    func updateTask(task: Task, newTitle: String, newDetails: String?, newReminderDate: Date?, priority: String, category: String) {
        task.title = newTitle
        task.details = newDetails
        task.reminderDate = newReminderDate
        task.priority = priority
        task.category = category
        saveContext()
        fetchAllTasks()
        
        // Cancela y programa un nuevo recordatorio si la fecha cambió
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.objectID.uriRepresentation().absoluteString])
        if let newReminderDate = newReminderDate {
            scheduleReminder(for: task)
        }
    }
    
    func deleteTask(task: Task) {
        // Cancela cualquier recordatorio asociado con esta tarea
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.objectID.uriRepresentation().absoluteString])
        
        context.delete(task)
        saveContext()
    }
    
    func fetchAllTasks() {
        let request = Task.fetchAllTaskRequest()
        do {
            tasks = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    // Programa un recordatorio para una tarea
    func scheduleReminder(for task: Task) {
        guard let reminderDate = task.reminderDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = task.title ?? "No Title"
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: task.objectID.uriRepresentation().absoluteString, // Usa un identificador único
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
    
    
    func toggleTaskCompletion(task: Task) {
        task.isCompleted.toggle()  // Cambia el estado de la tarea
        saveContext()              // Guarda los cambios en el contexto
        fetchAllTasks()            // Actualiza la lista de tareas
    }

}
