import SwiftUI

struct AddingExerciseCard: View {
    @Binding var name: String
    @Binding var setsText: String
    @Binding var reps: String
    var onSave: () -> Void
    var canSave: Bool
    var embedded: Bool = false
    
    @FocusState private var focusedField: Field?
    private enum Field {
        case name, sets, reps
    }
    
    var body: some View {
        let content = VStack(spacing: 0) {
            TextField("Exercise Name", text: $name)
                .textInputAutocapitalization(.words)
                .foregroundColor(.white)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit { focusedField = .sets }
                .padding(.top, 12)
                .padding(.bottom, 6)
                .padding(.horizontal, 12)
            
            Divider().overlay(Color.white.opacity(0.15))
                .padding(.horizontal, 8)
            
            TextField("Number of Sets", text: $setsText)
                .keyboardType(.numberPad)
                .foregroundColor(.white)
                .focused($focusedField, equals: .sets)
                .submitLabel(.next)
                .onSubmit { focusedField = .reps }
                .padding(.top, 12)
                .padding(.bottom, 6)
                .padding(.horizontal, 12)
            
            Divider().overlay(Color.white.opacity(0.15))
                .padding(.horizontal, 8)
            
            TextField("Rep Range", text: $reps)
                .foregroundColor(.white)
                .focused($focusedField, equals: .reps)
                .submitLabel(.done)
                .onSubmit { if canSave { onSave() } }
                .padding(.top, 12)
                .padding(.bottom, 2)
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
        
        if embedded {
            content
                .onAppear { focusedField = .name }
        } else {
            content
                .glassCard(cornerRadius: 18, padding: 16)
                .onAppear { focusedField = .name }
        }
    }
}

#Preview {
    ZStack {
        CustomBackgroundView()
        AddingExerciseCard(name: .constant(""), setsText: .constant(""), reps: .constant(""), onSave: {}, canSave: true)
            .padding()
    }
    .preferredColorScheme(.dark)
}
