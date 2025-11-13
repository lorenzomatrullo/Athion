import SwiftUI
import SwiftData

@main
struct AthionApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("isSignedIn") private var isSignedIn: Bool = false
    @State private var activeContainer: ModelContainer = StorageController.makeContainer(
        isSignedIn: UserDefaults.standard.bool(forKey: "isSignedIn")
    )
    
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
        .modelContainer(activeContainer)
        .onChange(of: isSignedIn) { _, newValue in
            // Live switch containers without relaunch
            if newValue {
                // When signing in, migrate local data (once) to CloudKit-backed store
                activeContainer = StorageController.migrateLocalToCloudIfNeeded()
            } else {
                activeContainer = StorageController.makeContainer(isSignedIn: false)
            }
        }
    }
}
