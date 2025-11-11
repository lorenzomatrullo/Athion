import SwiftUI

struct AddSessionFlowView: View {
    @Environment(\.dismiss) private var dismiss
    
    var onComplete: (WorkoutSession) -> Void
    
    @State private var sessionName: String = ""
    @State private var exerciseCountText: String = ""
    
    private var exerciseCount: Int {
        Int(exerciseCountText) ?? 0
    }
    
    private var canSave: Bool {
        !sessionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && exerciseCount > 0
    }
    
    var body: some View {
        ZStack {
            BlurredBackgroundView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    VStack(alignment: .leading, spacing: 2) {
                        Text("New Session")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Create a workout template")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 16)
                    
                    // Name field
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
                    
                    // Exercise count field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Number of exercises")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.7))
                        TextField("e.g., 6", text: $exerciseCountText)
                            .keyboardType(.numberPad)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .glassCard(cornerRadius: 18, padding: 0)
                    }
                    .padding(.horizontal, 16)
                    
                    // Save button
                    Button(action: save) {
                        Text("Create Session")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .solidCard(cornerRadius: 18, padding: 0)
                    }
                    .opacity(canSave ? 1.0 : 0.5)
                    .disabled(!canSave)
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 16)
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Close") { dismiss() }
                    .foregroundColor(.white.opacity(0.9))
            }
        }
    }
    
    private func save() {
        guard canSave else { return }
        let newSession = WorkoutSession(
            name: sessionName.trimmingCharacters(in: .whitespacesAndNewlines),
            exerciseCount: exerciseCount,
            date: Date(),
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


