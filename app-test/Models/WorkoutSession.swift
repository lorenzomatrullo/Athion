import Foundation

struct WorkoutSession: Identifiable {
    let id: UUID
    let name: String
    let exerciseCount: Int
    let date: Date
    let status: WorkoutStatus
    
    init(id: UUID = UUID(), name: String, exerciseCount: Int, date: Date = Date(), status: WorkoutStatus = .template) {
        self.id = id
        self.name = name
        self.exerciseCount = exerciseCount
        self.date = date
        self.status = status
    }
}

enum WorkoutStatus {
    case template
    case inProgress
    case completed
}

// Sample data for previews
extension WorkoutSession {
    static let sampleSessions: [WorkoutSession] = [
        WorkoutSession(name: "Chest & Biceps", exerciseCount: 6, date: Date(), status: .template),
        WorkoutSession(name: "Pull Day", exerciseCount: 5, date: Date().addingTimeInterval(-86400), status: .completed),
        WorkoutSession(name: "Shoulders", exerciseCount: 4, date: Date().addingTimeInterval(-172800), status: .completed),
        WorkoutSession(name: "Leg Day", exerciseCount: 6, date: Date().addingTimeInterval(-259200), status: .completed),
        WorkoutSession(name: "Full Body", exerciseCount: 8, date: Date().addingTimeInterval(-345600), status: .completed)
    ]
}

