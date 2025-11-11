import SwiftUI
import SwiftData

@main
struct AthionApp: App {
    var body: some Scene {
        WindowGroup {
            AppPreview()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [WorkoutSessionRecord.self, ExerciseRecord.self])
    }
}
