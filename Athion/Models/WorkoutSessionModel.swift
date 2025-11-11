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
