import SwiftUI
import UniformTypeIdentifiers

struct ReorderableExercisesList: View {
    @Binding var exercises: [Exercise]
    var onDelete: (Exercise) -> Void
    
    // Inline edit state (same UX as ExercisesList)
    @State private var editingIndex: Int? = nil
    @State private var nameDraft: String = ""
    @State private var setsTextDraft: String = ""
    @State private var repsDraft: String = ""
    @State private var showingDeleteAlertForIndex: Int? = nil
    
    // Drag state
    @State private var draggingItem: Exercise? = nil
    
    private var setsDraft: Int { Int(setsTextDraft) ?? 0 }
    
    private var canSaveDraft: Bool {
        !nameDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        setsDraft > 0 &&
        !repsDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(exercises.enumerated()), id: \.element.id) { index, ex in
                if editingIndex == index {
                    AddingExerciseCard(
                        name: $nameDraft,
                        setsText: $setsTextDraft,
                        reps: $repsDraft,
                        onSave: { saveDraft(at: index) },
                        canSave: canSaveDraft,
                        embedded: true
                    )
                    .glassCard(cornerRadius: 16, padding: 0)
                    .transition(.opacity)
                } else {
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
                        Button(role: .destructive) {
                            showingDeleteAlertForIndex = index
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .glassCard(cornerRadius: 16, padding: 0)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        beginEditing(exerciseAt: index)
                    }
                    .onDrag {
                        draggingItem = ex
                        return NSItemProvider(object: ex.id.uuidString as NSString)
                    }
                    .onDrop(of: [UTType.text.identifier], delegate: ExerciseDropDelegate(
                        item: ex,
                        items: $exercises,
                        current: $draggingItem
                    ))
                    .alert("Delete Exercise", isPresented: Binding<Bool>(
                        get: { showingDeleteAlertForIndex == index },
                        set: { newValue in if !newValue { showingDeleteAlertForIndex = nil } }
                    )) {
                        Button("Cancel", role: .cancel) {}
                        Button("Delete", role: .destructive) {
                            onDelete(ex)
                        }
                    }
                }
            }
        }
    }
    
    private func beginEditing(exerciseAt index: Int) {
        guard exercises.indices.contains(index) else { return }
        let ex = exercises[index]
        nameDraft = ex.name
        setsTextDraft = String(ex.sets)
        repsDraft = ex.reps
        withAnimation(.bouncy(duration: 0.5)) { editingIndex = index }
    }
    
    private func saveDraft(at index: Int) {
        guard exercises.indices.contains(index), canSaveDraft else { return }
        exercises[index].name = nameDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        exercises[index].sets = setsDraft
        exercises[index].reps = repsDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        nameDraft = ""
        setsTextDraft = ""
        repsDraft = ""
        withAnimation(.bouncy(duration: 0.5)) { editingIndex = nil }
    }
}

private struct ExerciseDropDelegate: DropDelegate {
    let item: Exercise
    @Binding var items: [Exercise]
    @Binding var current: Exercise?
    
    func validateDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let dragging = current, dragging != item,
              let from = items.firstIndex(of: dragging),
              let to = items.firstIndex(of: item) else { return }
        if from != to {
            withAnimation(.easeInOut(duration: 0.15)) {
                let moved = items.remove(at: from)
                items.insert(moved, at: to)
            }
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}

#Preview {
    ZStack {
        CustomBackgroundView()
        StatefulPreviewWrapper([
            Exercise(name: "Bench Press", sets: 4, reps: "8-10"),
            Exercise(name: "Incline DB Press", sets: 3, reps: "10-12"),
            Exercise(name: "Cable Flyes", sets: 3, reps: "12-15")
        ]) { $items in
            ReorderableExercisesList(exercises: $items, onDelete: { ex in
                if let idx = items.firstIndex(of: ex) { items.remove(at: idx) }
            })
            .padding(.horizontal, 16)
        }
    }
    .preferredColorScheme(.dark)
}
