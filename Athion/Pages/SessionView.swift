import SwiftUI
import UIKit
import SwiftData

struct SessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutSessionRecord.date, order: .reverse) private var sessionRecords: [WorkoutSessionRecord]
    @State private var showingAddSession = false
    @State private var viewingRecord: WorkoutSessionRecord?
    
    init() {
        // Configure navigation bar appearance for dark theme
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackgroundView()
                
                ScrollView {
                    VStack(spacing: 16) {
                        if sessionRecords.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "dumbbell.fill")
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                Text("No sessions yet")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Tap the + button to add your first workout.")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 60)
                            .padding(.horizontal, 16)
                        } else {
                            ForEach(Array(sessionRecords.prefix(4)), id: \.id) { record in
                                let session = WorkoutSession(
                                    id: record.id,
                                    name: record.name,
                                    exerciseCount: (record.exercises ?? []).count,
                                    date: record.date,
                                    status: .template
                                )
                                WorkoutSessionCard(
                                    session: session,
                                    onTap: {
                                        viewingRecord = record
                                    },
                                    onDelete: {
                                        // Delete the session and its associated logs
                                        // First remove ExerciseSetLog entries linked to this session
                                        let sessionId = record.id
                                        let descriptor = FetchDescriptor<ExerciseSetLog>(
                                            predicate: #Predicate<ExerciseSetLog> { log in
                                                log.sessionId == sessionId
                                            }
                                        )
                                        if let logs = try? modelContext.fetch(descriptor) {
                                            for log in logs {
                                                modelContext.delete(log)
                                            }
                                        }
                                        // Then delete the session
                                        modelContext.delete(record)
                                        try? modelContext.save()
                                    }
                                )
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 80) // Space for floating button
                }
                
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        startNewWorkout()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Sessions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.abbreviated)))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.leading, 20)
                .padding(.top, -50)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationDestination(isPresented: $showingAddSession) {
                // Render from SwiftData via @Query, no need to mutate local state here.
                AddSessionFlowView { _ in }
                    .preferredColorScheme(.dark)
            }
            .navigationDestination(item: $viewingRecord) { rec in
                SessionOverviewView(record: rec)
                    .preferredColorScheme(.dark)
            }
        }
    }
    
    private func startNewWorkout() {
        showingAddSession = true
    }
}

#Preview {
    SessionView()
        .preferredColorScheme(.dark)
}
