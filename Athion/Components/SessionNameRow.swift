import SwiftUI

struct SessionNameRow: View {
    let isEditing: Bool
    @Binding var sessionName: String
    let recordName: String
    let rowMinHeight: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
            
            Group {
                if isEditing {
                    TextField("e.g., Push Day", text: $sessionName)
                        .textInputAutocapitalization(.words)
                        .foregroundColor(.white)
                } else {
                    HStack {
                        Text(recordName)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .frame(minHeight: rowMinHeight)
            .glassCard(cornerRadius: 18, padding: 0)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        CustomBackgroundView()
        VStack(spacing: 16) {
            SessionNameRow(isEditing: false, sessionName: .constant("Push Day"), recordName: "Push Day", rowMinHeight: 44)
            SessionNameRow(isEditing: true, sessionName: .constant("Push Day"), recordName: "Push Day", rowMinHeight: 44)
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}
