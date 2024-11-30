//
//  TaskDetailView.swift
//  ToDoSwiftUI
//
//  Created by DAMII on 15/10/24.
//

import SwiftUI

struct TaskDetailView: View {
    @State var title: String
    @State var details: String
    @State var reminderDate: Date?
    @State var priority: String = "Low"
    @State var category: String = "Work"
    @Environment(\.dismiss) var dismiss

    
    let onSave: (String, String, Date?, String, String) -> Void

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Task Title", text: $title)
            }
            
            Section(header: Text("Details")) {
                TextEditor(text: $details)
                    .frame(height: 100)
            }
            
            Section(header: Text("Reminder")) {
                DatePicker("Set Reminder", selection: Binding(
                    get: { reminderDate ?? Date() },
                    set: { reminderDate = $0 }
                ), displayedComponents: [.date, .hourAndMinute])
            }
            
            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority) {
                    Text("Low").tag("Low")
                    Text("Medium").tag("Medium")
                    Text("High").tag("High")
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Category")) {
                Picker("Category", selection: $category) {
                    Text("Work").tag("Work")
                    Text("Study").tag("Study")
                    Text("Home").tag("Home")
                }
                .pickerStyle(SegmentedPickerStyle())
            }


        }
        .navigationTitle("Task Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    onSave(title, details, reminderDate, priority, category)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    TaskDetailView(
        title: "Sample Task",
        details: "This is a sample task description.",
        reminderDate: nil,
        priority: "Low",
        category: "Work"
    ) { title, details, reminderDate, priority, category in
        // Acción de ejemplo para guardar
    }
}



