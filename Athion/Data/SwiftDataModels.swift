import Foundation
import SwiftData

@Model
final class WorkoutSessionRecord {
    var id: UUID = UUID()
    var name: String = ""
    var date: Date = Date()
    @Relationship(deleteRule: .cascade, inverse: \ExerciseRecord.session) var exercises: [ExerciseRecord]?
    
    init(id: UUID = UUID(), name: String, date: Date = Date()) {
        self.id = id
        self.name = name
        self.date = date
    }
}

@Model
final class ExerciseRecord {
    var id: UUID = UUID()
    var name: String = ""
    var sets: Int = 0
    var reps: String = ""
    // Stable ordering within a session
    var orderIndex: Int = 0
    
    var session: WorkoutSessionRecord?
    
    init(id: UUID = UUID(), name: String, sets: Int, reps: String, session: WorkoutSessionRecord? = nil, orderIndex: Int = 0) {
        self.id = id
        self.name = name
        self.sets = sets
        self.reps = reps
        self.session = session
        self.orderIndex = orderIndex
    }
}
