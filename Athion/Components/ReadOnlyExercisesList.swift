import SwiftUI
import SwiftData

struct ReadOnlyExercisesList: View {
    let exercises: [ExerciseRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(exercises, id: \.id) { ex in
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

#Preview {
    let record = WorkoutSessionRecord(name: "Preview", date: Date())
    record.exercises = [
        ExerciseRecord(name: "Bench Press", sets: 4, reps: "8-10", session: record),
        ExerciseRecord(name: "Incline DB Press", sets: 3, reps: "10-12", session: record)
    ]
    return ZStack {
        CustomBackgroundView()
        ReadOnlyExercisesList(exercises: record.exercises)
            .padding(.top, 24)
    }
    .preferredColorScheme(.dark)
}
