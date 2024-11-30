//
//  ContentView.swift
//  ToDoSwiftUI
//
//  Created by DAMII on 15/10/24.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.tasks) { task in
                    NavigationLink(destination: TaskDetailView(
                        title: task.title ?? "",
                        details: task.details ?? "",
                        reminderDate: task.reminderDate,
                        priority: task.priority ?? "Low", // Valor predeterminado para priority
                        category: task.category ?? "Work" // Valor predeterminado para category
                    ) { newTitle, newDetails, newReminderDate, newPriority, newCategory in
                        viewModel.updateTask(
                            task: task,              // Tarea a actualizar
                            newTitle: newTitle,      // Nuevo título
                            newDetails: newDetails,  // Nuevos detalles
                            newReminderDate: newReminderDate, // Nueva fecha de recordatorio
                            priority: newPriority,   // Nueva prioridad
                            category: newCategory    // Nueva categoría
                        )
                    }) {
                        VStack(alignment: .leading) {
                            Text(task.title ?? "No Title")
                                .font(.headline)
                            if let reminder = task.reminderDate {
                                Text("Reminder: \(reminder, formatter: DateFormatter.shortDateTimeFormatter)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { viewModel.deleteTask(task: viewModel.tasks[$0]) }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: TaskDetailView(
                        title: "",
                        details: "",
                        reminderDate: nil,
                        priority: "Low", // Valor predeterminado para priority
                        category: "Work" // Valor predeterminado para category
                    ) { title, details, reminderDate, priority, category in
                        viewModel.addTask(
                            title: title,         // Título de la nueva tarea
                            details: details,     // Detalles de la nueva tarea
                            reminderDate: reminderDate, // Fecha de recordatorio
                            priority: priority,   // Prioridad de la nueva tarea
                            category: category    // Categoría de la nueva tarea
                        )
                    }) {
                        Image(systemName: "plus")
                    }

                }
            }
        }
    }
}

extension DateFormatter {
    static var shortDateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    TaskListView()
}
