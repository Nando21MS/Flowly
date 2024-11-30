import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = TaskListViewModel()
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    @State private var tasksForSelectedDate: [Task] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Selector de mes, día y año en una fila
                HStack(spacing: 16) {
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text(Calendar.current.monthSymbols[month - 1]).tag(month)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)

                    Picker("Day", selection: $selectedDay) {
                        ForEach(daysInMonth(for: selectedMonth, year: selectedYear), id: \.self) { day in
                            Text("\(day)").tag(day)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 80)

                    Picker("Year", selection: $selectedYear) {
                        ForEach(2020...2030, id: \.self) { year in
                            Text("\(year)").tag(year)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 80)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )

                Divider()

                // Lista de tareas
                VStack(alignment: .leading) {
                    Text("Tasks for Selected Date")
                        .font(.headline)
                        .padding(.bottom, 10)

                    if tasksForSelectedDate.isEmpty {
                        Text("No tasks for this day")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    } else {
                        List(tasksForSelectedDate) { task in
                            NavigationLink(destination: TaskDetailView(
                                title: task.title ?? "",
                                details: task.details ?? "",
                                reminderDate: task.reminderDate
                            ) { newTitle, newDetails, newReminderDate in
                                viewModel.updateTask(task: task, newTitle: newTitle, newDetails: newDetails, newReminderDate: newReminderDate)
                            }) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(task.title ?? "No Title")
                                        .font(.headline)
                                        .lineLimit(1)
                                    if let reminder = task.reminderDate {
                                        Text("Reminder: \(reminder, formatter: DateFormatter.shortDateTimeFormatter)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .shadow(radius: 4)
                )
            }
            .padding()
            .navigationTitle("Calendar")
            .onChange(of: selectedDay) { _ in
                filterTasksForSelectedDate()
            }
            .onChange(of: selectedMonth) { _ in
                selectedDay = 1 // Reiniciar día al cambiar de mes
                filterTasksForSelectedDate()
            }
            .onChange(of: selectedYear) { _ in
                filterTasksForSelectedDate()
            }
        }
    }

    // Filtrar tareas según la fecha seleccionada
    private func filterTasksForSelectedDate() {
        let selectedDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay))!
        tasksForSelectedDate = viewModel.tasks.filter { task in
            guard let reminderDate = task.reminderDate else { return false }
            return Calendar.current.isDate(reminderDate, inSameDayAs: selectedDate)
        }
    }

    // Obtener el número de días en el mes seleccionado
    private func daysInMonth(for month: Int, year: Int) -> [Int] {
        var components = DateComponents()
        components.year = year
        components.month = month

        let calendar = Calendar.current
        guard let date = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: date) else {
            return []
        }
        return Array(range)
    }
}

#Preview {
    CalendarView()
}
