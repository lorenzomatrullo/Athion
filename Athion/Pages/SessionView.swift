import SwiftUI
import UIKit
import SwiftData

struct SessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutSessionRecord.date, order: .reverse) private var sessionRecords: [WorkoutSessionRecord]
    @State private var showingAddSession = false
    
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
                        ForEach(Array(sessionRecords.prefix(4)), id: \.id) { record in
                            let session = WorkoutSession(
                                id: record.id,
                                name: record.name,
                                exerciseCount: record.exercises.count,
                                date: record.date,
                                status: .template
                            )
                            WorkoutSessionCard(
                                session: session,
                                onTap: {
                                    // tap handling could navigate to details in future
                                },
                                onDelete: {
                                    modelContext.delete(record)
                                    try? modelContext.save()
                                }
                            )
                            .padding(.horizontal, 16)
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
                // We render from SwiftData via @Query, so we don't need to mutate local state here.
                AddSessionFlowView { _ in }
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
