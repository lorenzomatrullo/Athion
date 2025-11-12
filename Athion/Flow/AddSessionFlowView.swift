import SwiftUI
import SwiftData

struct AddSessionFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var onComplete: (WorkoutSession) -> Void
    
    @State private var sessionName: String = ""
    @State private var exercises: [Exercise] = []
    
    // Inline exercise fields
    @State private var exName: String = ""
    @State private var exSetsText: String = ""
    @State private var exReps: String = ""
    @State private var isAddingExercise: Bool = false
    
    private var exSets: Int { Int(exSetsText) ?? 0 }
    
    private var canSaveExercise: Bool {
        !exName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        exSets > 0 &&
        !exReps.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var canSaveSession: Bool {
        !sessionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !exercises.isEmpty
    }
    
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
                            TextField("e.g., Push Day", text: $sessionName)
                                .textInputAutocapitalization(.words)
                                .foregroundColor(.white)
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
                        
                        // Exercises overview (shown ABOVE add button)
                        if !exercises.isEmpty {
                            ExercisesList(
                                exercises: $exercises,
                                onDelete: { ex in
                                    if let idx = exercises.firstIndex(of: ex) { exercises.remove(at: idx) }
                                }
                            )
                            .padding(.horizontal, 16)
                        }
                        
                        // Inline exercise entry card
                        if isAddingExercise {
                            AddingExerciseCard(name: $exName, setsText: $exSetsText, reps: $exReps, onSave: saveExercise, canSave: canSaveExercise)
                                .padding(.horizontal, 16)
                        }
                        
                        // Add Exercise button
                        Button(action: {
                            // Start a fresh add; clear fields and reset editing state
                            dismissKeyboard()
                            exName = ""
                            exSetsText = ""
                            exReps = ""
                            withAnimation { isAddingExercise = true }
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Add Exercise")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .solidCard(cornerRadius: 18, padding: 0)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("New Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: saveSession) {
                        Image(systemName: "checkmark")
                    }
                    .disabled(!canSaveSession)
                    .opacity(canSaveSession ? 1.0 : 0.5)
                    .foregroundColor(.white.opacity(0.9))
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    private func saveExercise() {
        guard canSaveExercise else { return }
        dismissKeyboard()
        let trimmedName = exName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedReps = exReps.trimmingCharacters(in: .whitespacesAndNewlines)
        // Insert new exercise (editing handled inside ExercisesList)
        let ex = Exercise(name: trimmedName, sets: exSets, reps: trimmedReps)
        exercises.append(ex)
        exName = ""
        exSetsText = ""
        exReps = ""
        withAnimation { isAddingExercise = false }
    }
    
    private func saveSession() {
        guard canSaveSession else { return }
        let record = WorkoutSessionRecord(name: sessionName.trimmingCharacters(in: .whitespacesAndNewlines), date: Date())
        for ex in exercises {
            let exRec = ExerciseRecord(name: ex.name, sets: ex.sets, reps: ex.reps, session: record)
            record.exercises.append(exRec)
        }
        modelContext.insert(record)
        try? modelContext.save()
        
        let newSession = WorkoutSession(
            name: record.name,
            exerciseCount: record.exercises.count,
            date: record.date,
            status: .template
        )
        onComplete(newSession)
        dismiss()
    }
}

#Preview {
    AddSessionFlowView { _ in }
        .preferredColorScheme(.dark)
}
