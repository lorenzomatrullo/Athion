import SwiftUI
import SwiftData

struct ActiveWorkoutView: View {
    let record: WorkoutSessionRecord
    var onFinish: (() -> Void)? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    struct SetEntry: Identifiable, Hashable {
        let id = UUID()
        var weightKg: String
        var reps: String
        var isCompleted: Bool = false
    }
    
    struct ExerciseEntry: Identifiable {
        let id = UUID()
        let name: String
        let repsRange: String
        var sets: [SetEntry]
    }
    
    @State private var exercises: [ExerciseEntry] = []
    @State private var showingFinishConfirm: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackgroundView()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(exercises) { ex in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.white.opacity(0.12))
                                            .frame(width: 42, height: 42)
                                        Image(systemName: "figure.strengthtraining.traditional")
                                            .foregroundColor(.white)
                                    }
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(ex.name)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Text(ex.repsRange)
                                            .foregroundColor(.white.opacity(0.7))
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                }
                                
                                ForEach(Array(ex.sets.enumerated()), id: \.element.id) { idx, set in
                                    HStack(spacing: 12) {
                                        // Completion gate: both weight and reps must be provided and set not already completed
                                        let isFilled = !set.weightKg.trimmingCharacters(in: .whitespaces).isEmpty
                                        && !set.reps.trimmingCharacters(in: .whitespaces).isEmpty
                                        let canComplete = isFilled && !set.isCompleted
                                        let showDisabledLook = !isFilled && !set.isCompleted
                                        
                                        // Set number bullet
                                        ZStack {
                                            Circle()
                                                .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
                                                .background(Circle().fill(Color.white.opacity(0.08)))
                                                .frame(width: 36, height: 36)
                                            Text("\(idx + 1)")
                                                .foregroundColor(.white)
                                                .fontWeight(.semibold)
                                        }
                                        
                                        // Weight field (kg)
                                        HStack {
                                            TextField("0", text: bindingForSet(exerciseId: ex.id, setId: set.id, keyPath: \.weightKg))
                                                .keyboardType(.decimalPad)
                                                .foregroundColor(.white)
                                            Text("kg")
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                                        
                                        // Reps field
                                        HStack {
                                            TextField("0", text: bindingForSet(exerciseId: ex.id, setId: set.id, keyPath: \.reps))
                                                .keyboardType(.numberPad)
                                                .foregroundColor(.white)
                                            Text("reps")
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 12)
                                        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                                        
                                        // Done button (UI only; match set-number circle style and size)
                                        Button(action: {
                                            if canComplete {
                                                completeSet(exerciseId: ex.id, setId: set.id)
                                            }
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .strokeBorder(set.isCompleted ? Color.green : Color.white.opacity(0.25), lineWidth: 1)
                                                    .background(
                                                        Circle().fill(
                                                            set.isCompleted ? Color.green.opacity(0.35) : Color.white.opacity(0.08)
                                                        )
                                                    )
                                                Image(systemName: "checkmark")
                                                    .font(.system(size: 16, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                            .frame(width: 36, height: 36)
                                        }
                                        .padding(.leading, 8) // tighter gap next to reps field
                                        .buttonStyle(.plain)
                                        // Default state (not filled) uses disabled look; completed green keeps full look but is not tappable
                                        .disabled(showDisabledLook)
                                        .allowsHitTesting(canComplete) // ignore taps unless we can complete
                                    }
                                }
                            }
                            .glassCard(cornerRadius: 20, padding: 16)
                            .padding(.horizontal, 16)
                        }
                        
                        Spacer(minLength: 24)
                        
                        Button(action: { showingFinishConfirm = true }) {
                            HStack {
                                Spacer()
                                Text("Finish Session")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
                            .solidCard(cornerRadius: 18, padding: 0)
                        }
                        .confirmationDialog("Finish workout?", isPresented: $showingFinishConfirm, titleVisibility: .visible) {
                            Button("Finish", role: .destructive) {
                                onFinish?()
                                dismiss()
                            }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("You can’t return to this screen after finishing.")
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                    .padding(.top, 12)
                }
            }
            .interactiveDismissDisabled(true)
            .navigationTitle("Log activity")
            .navigationBarTitleDisplayMode(.inline)
            .keyboardDismissToolbar()
        }
        .onAppear(perform: bootstrap)
    }
    
    private func bootstrap() {
        // Build transient entries from the session's exercises (sorted by orderIndex)
        let source = (record.exercises ?? []).sorted { $0.orderIndex < $1.orderIndex }
        exercises = source.map { ex in
            let setCount = max(1, ex.sets)
            // Start reps empty so the user can input completed reps, while the header shows the planned range.
            let sets = Array(0..<setCount).map { _ in SetEntry(weightKg: "", reps: "", isCompleted: false) }
            return ExerciseEntry(name: ex.name, repsRange: ex.reps, sets: sets)
        }
    }
    
    private func bindingForSet(exerciseId: UUID, setId: UUID, keyPath: WritableKeyPath<SetEntry, String>) -> Binding<String> {
        Binding<String>(
            get: {
                guard let exIndex = exercises.firstIndex(where: { $0.id == exerciseId }),
                      let setIndex = exercises[exIndex].sets.firstIndex(where: { $0.id == setId }) else { return "" }
                return exercises[exIndex].sets[setIndex][keyPath: keyPath]
            },
            set: { newValue in
                guard let exIndex = exercises.firstIndex(where: { $0.id == exerciseId }),
                      let setIndex = exercises[exIndex].sets.firstIndex(where: { $0.id == setId }) else { return }
                exercises[exIndex].sets[setIndex][keyPath: keyPath] = newValue
            }
        )
    }
    
    private func completeSet(exerciseId: UUID, setId: UUID) {
        guard let exIndex = exercises.firstIndex(where: { $0.id == exerciseId }),
              let setIndex = exercises[exIndex].sets.firstIndex(where: { $0.id == setId }) else { return }
        // If already completed, do nothing (cannot undo)
        if exercises[exIndex].sets[setIndex].isCompleted { return }
        exercises[exIndex].sets[setIndex].isCompleted = true
    }
}

#Preview {
    let record = WorkoutSessionRecord(name: "Leg Day", date: .now)
    record.exercises = [
        ExerciseRecord(name: "Back Squat", sets: 3, reps: "10", session: record),
        ExerciseRecord(name: "Leg Extensions", sets: 3, reps: "10", session: record),
        ExerciseRecord(name: "Leg Extensions", sets: 3, reps: "10", session: record),
        ExerciseRecord(name: "Leg Extensions", sets: 3, reps: "10", session: record)
    ]
    return ActiveWorkoutView(record: record).preferredColorScheme(.dark)
}
