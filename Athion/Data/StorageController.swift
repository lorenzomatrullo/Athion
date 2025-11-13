import Foundation
import SwiftData

enum StorageController {
    static let cloudContainerId = "iCloud.com.lorenzomatrullo.athion"
    
    static func makeContainer(isSignedIn: Bool) -> ModelContainer {
        let database: ModelConfiguration.CloudKitDatabase = isSignedIn ? .private(cloudContainerId) : .none
        // Separate stores so local and cloud data don't overwrite each other
        let fm = FileManager.default
        let supportDir = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        // Put SwiftData stores under a dedicated subfolder and ensure it exists
        let storesDir = supportDir.appendingPathComponent("SwiftDataStores", isDirectory: true)
        try? fm.createDirectory(at: storesDir, withIntermediateDirectories: true)
        // Conventional sqlite filenames
        let storeURL = storesDir.appendingPathComponent(isSignedIn ? "cloud.sqlite" : "local.sqlite")
        let config = ModelConfiguration(url: storeURL, cloudKitDatabase: database)
        do {
            return try ModelContainer(
                for: WorkoutSessionRecord.self, ExerciseRecord.self, ExerciseSetLog.self,
                configurations: config
            )
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }
    
    // Copy local data to the CloudKit-backed store the first time a user signs in
    static func migrateLocalToCloudIfNeeded() -> ModelContainer {
        // Build target cloud container
        let cloudContainer = makeContainer(isSignedIn: true)
        let cloudContext = ModelContext(cloudContainer)
        // If cloud already has data, skip migration
        let cloudCount = (try? cloudContext.fetchCount(FetchDescriptor<WorkoutSessionRecord>())) ?? 0
        guard cloudCount == 0 else { return cloudContainer }
        
        // Read from local container
        let localContainer = makeContainer(isSignedIn: false)
        let localContext = ModelContext(localContainer)
        let localSessions = (try? localContext.fetch(FetchDescriptor<WorkoutSessionRecord>())) ?? []
        
        // Clone into cloud context
        for session in localSessions {
            let newSession = WorkoutSessionRecord(name: session.name, date: session.date)
            let exercises = (session.exercises ?? []).sorted { $0.orderIndex < $1.orderIndex }
            for ex in exercises {
                let _ = ExerciseRecord(
                    name: ex.name,
                    sets: ex.sets,
                    reps: ex.reps,
                    session: newSession,
                    orderIndex: ex.orderIndex
                )
            }
            cloudContext.insert(newSession)
        }
        try? cloudContext.save()
        return cloudContainer
    }
}
