import SwiftUI
import SwiftData

struct SessionOverviewView: View {
    @Environment(\.modelContext) private var modelContext
    
    let record: WorkoutSessionRecord
    
    // Edit mode state
    private let nameRowMinHeight: CGFloat = 44
    @State private var isEditing: Bool = false
    @State private var sessionName: String = ""
    @State private var exercises: [Exercise] = []
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
        ZStack {
            CustomBackgroundView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Session name
                    SessionNameRow(
                        isEditing: isEditing,
                        sessionName: $sessionName,
                        recordName: record.name,
                        rowMinHeight: nameRowMinHeight
                    )
                    
                    // Exercises header
                    Text("Exercises")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                    
                    // List (read-only or editable)
                    Group {
                        if isEditing {
                            if !exercises.isEmpty {
                                ExercisesList(
                                    exercises: $exercises,
                                    onDelete: { ex in
                                        if let idx = exercises.firstIndex(of: ex) { exercises.remove(at: idx) }
                                    }
                                )
                                .padding(.horizontal, 16)
                            }
                            if isAddingExercise {
                                AddingExerciseCard(name: $exName, setsText: $exSetsText, reps: $exReps, onSave: saveExercise, canSave: canSaveExercise)
                                    .padding(.horizontal, 16)
                            }
                            Button(action: {
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
                        } else {
                            if !record.exercises.isEmpty {
                                ReadOnlyExercisesList(exercises: record.exercises)
                            }
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(isEditing ? "Session Edit" : "Session")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                if isEditing {
                    Button(action: saveEdits) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(width: 28, height: 28)
                    }
                    .disabled(!canSaveSession)
                    .opacity(canSaveSession ? 1.0 : 0.5)
                    .foregroundColor(.white.opacity(0.9))
                } else {
                    HStack(spacing: 18) {
                        Button {
                            enterEditMode()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 28, height: 28)
                                .offset(y: -1)
                        }
                        .foregroundColor(.white.opacity(0.9))
                        
                        // Start button (hook up backend later)
                        Button {
                            // TODO: start session action
                        } label: {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 28, height: 28)
                        }
                        .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
        }
        // Animate toolbar expansion/collapse when toggling edit mode
        .animation(.easeInOut(duration: 0.2), value: isEditing)
        .onAppear {
            // Ensure we reset edit buffer if needed
            if !isEditing {
                sessionName = record.name
            }
        }
    }
    
    private func enterEditMode() {
        dismissKeyboard()
        sessionName = record.name
        exercises = record.exercises.map { Exercise(id: $0.id, name: $0.name, sets: $0.sets, reps: $0.reps) }
        withAnimation(.easeInOut(duration: 0.2)) {
            isEditing = true
        }
    }
    
    private func saveExercise() {
        guard canSaveExercise else { return }
        dismissKeyboard()
        let trimmedName = exName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedReps = exReps.trimmingCharacters(in: .whitespacesAndNewlines)
        let ex = Exercise(name: trimmedName, sets: exSets, reps: trimmedReps)
        exercises.append(ex) // append to end
        exName = ""
        exSetsText = ""
        exReps = ""
        withAnimation { isAddingExercise = false }
    }
    
    private func saveEdits() {
        guard canSaveSession else { return }
        dismissKeyboard()
        let trimmed = sessionName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Early exit if nothing actually changed
        let noNameChange = record.name == trimmed
        let sameCount = record.exercises.count == exercises.count
        let sameContent = sameCount && zip(record.exercises, exercises).allSatisfy { rec, ex in
            rec.name == ex.name && rec.sets == ex.sets && rec.reps == ex.reps
        }
        if noNameChange && sameContent {
            isEditing = false
            return
        }
        
        // Persist edits
        record.name = trimmed
        
        // Replace exercise records safely. Do NOT reuse ids to avoid SwiftData collisions.
        let toRemove = Array(record.exercises)
        for rec in toRemove {
            modelContext.delete(rec)
        }
        record.exercises.removeAll(keepingCapacity: false)
        
        for ex in exercises {
            let exRec = ExerciseRecord(name: ex.name, sets: ex.sets, reps: ex.reps, session: record)
            record.exercises.append(exRec)
        }
        
        try? modelContext.save()
        withAnimation(.easeInOut(duration: 0.2)) {
            isEditing = false
        }
    }
}

#Preview {
    // Create a sample record for preview
    let record = WorkoutSessionRecord(name: "Push Day", date: Date())
    record.exercises = [
        ExerciseRecord(name: "Bench Press", sets: 4, reps: "8-10", session: record),
        ExerciseRecord(name: "Incline DB Press", sets: 3, reps: "10-12", session: record)
    ]
    
    return NavigationStack {
        SessionOverviewView(record: record)
    }
    .preferredColorScheme(.dark)
}
