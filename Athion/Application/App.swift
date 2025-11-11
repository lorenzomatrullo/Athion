import SwiftUI
import SwiftData

@main
struct AthionApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    var body: some Scene {
        WindowGroup {
            AppPreview()
                .preferredColorScheme(.dark)
                .fullScreenCover(
                    isPresented: Binding(
                        get: { !hasCompletedOnboarding },
                        set: { _ in }
                    )
                ) {
                    OnboardingView {
                        hasCompletedOnboarding = true
                    }
                    .preferredColorScheme(.dark)
                }
        }
        .modelContainer(for: [WorkoutSessionRecord.self, ExerciseRecord.self])
    }
}
