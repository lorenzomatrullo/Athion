import SwiftUI
import SwiftData

struct SessionOverviewView: View {
    let record: WorkoutSessionRecord
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackgroundView()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Session name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Name")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.7))
                            HStack {
                                Text(record.name)
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .glassCard(cornerRadius: 18, padding: 0)
                        }
                        .padding(.horizontal, 16)
                        
                        // Exercises header
                        Text("Exercises")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                        
                        if !record.exercises.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(record.exercises, id: \.id) { ex in
                                    HStack(alignment: .center) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(ex.name)
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                            Text("\(ex.sets) sets · \(ex.reps) reps")
                                                .foregroundColor(.white.opacity(0.75))
                                                .font(.subheadline)
                                        }
                                        Spacer()
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .glassCard(cornerRadius: 16, padding: 0)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Session Overview")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    // Create a sample record for preview
    let record = WorkoutSessionRecord(name: "Push Day", date: Date())
    record.exercises = [
        ExerciseRecord(name: "Bench Press", sets: 4, reps: "8-10", session: record),
        ExerciseRecord(name: "Incline DB Press", sets: 3, reps: "10-12", session: record)
    ]
    
    return SessionOverviewView(record: record)
        .preferredColorScheme(.dark)
}
