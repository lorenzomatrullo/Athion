import SwiftUI

struct ExerciseEntryCard: View {
    @Binding var name: String
    @Binding var setsText: String
    @Binding var reps: String
    var onSave: () -> Void
    var canSave: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Exercise Name", text: $name)
                .textInputAutocapitalization(.words)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
            
            Divider().overlay(Color.white.opacity(0.15))
                .padding(.horizontal, 8)
            
            TextField("Number of Sets", text: $setsText)
                .keyboardType(.numberPad)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
            
            Divider().overlay(Color.white.opacity(0.15))
                .padding(.horizontal, 8)
            
            TextField("Rep Range", text: $reps)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
            
            Divider().overlay(Color.white.opacity(0.15))
                .padding(.horizontal, 8)
                .padding(.top, 6)
            
            Button(action: onSave) {
                HStack {
                    Text("Save Exercise")
                        .foregroundColor(canSave ? Color.blue : Color.white)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
            }
            .disabled(!canSave)
            .opacity(canSave ? 1.0 : 0.5)
            .padding(.bottom, -2)
        }
        .glassCard(cornerRadius: 18, padding: 16)
    }
}

#Preview {
    ZStack {
        CustomBackgroundView()
        ExerciseEntryCard(name: .constant(""), setsText: .constant(""), reps: .constant(""), onSave: {}, canSave: true)
            .padding()
    }
    .preferredColorScheme(.dark)
}
