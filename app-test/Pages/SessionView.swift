import SwiftUI
import UIKit

struct SessionView: View {
    @State private var workoutSessions: [WorkoutSession] = WorkoutSession.sampleSessions
    @State private var showingMenu = false
    @State private var selectedSession: WorkoutSession?
    
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
                BlurredBackgroundView()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Array(workoutSessions.prefix(4))) { session in
                            WorkoutSessionCard(
                                session: session,
                                onTap: {
                                    // Navigate to workout detail/active view
                                    selectedSession = session
                                },
                                onDelete: {
                                    if let index = workoutSessions.firstIndex(where: { $0.id == session.id }) {
                                        workoutSessions.remove(at: index)
                                    }
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
        }
    }
    
    private func startNewWorkout() {
        // Handle starting a new workout
    }
}

#Preview {
    SessionView()
        .preferredColorScheme(.dark)
}

