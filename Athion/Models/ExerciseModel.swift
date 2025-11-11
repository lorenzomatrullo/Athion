import Foundation

struct Exercise: Identifiable, Equatable {
    let id: UUID
    var name: String
    var sets: Int
    var reps: String
    
    init(id: UUID = UUID(), name: String, sets: Int, reps: String) {
        self.id = id
        self.name = name
        self.sets = sets
        self.reps = reps
    }
}
