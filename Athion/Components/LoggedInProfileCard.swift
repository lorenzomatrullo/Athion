import SwiftUI

struct LoggedInProfileCard: View {
    var title: String = "Signed in with Apple"
    var subtitle: String = "Your workouts are backed up and ready to sync."
    var displayName: String? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    if let displayName, !displayName.isEmpty {
                        Text("Hello, \(displayName)")
                            .foregroundColor(.white)
                            .font(.headline)
                    } else {
                        Text(title)
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    Text(subtitle)
                        .foregroundColor(.white.opacity(0.7))
                        .font(.subheadline)
                }
                Spacer()
                Image(systemName: "apple.logo")
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .glassCard(cornerRadius: 20, padding: 16)
    }
}

#Preview {
    ZStack {
        CustomBackgroundView()
        LoggedInProfileCard()
            .padding()
    }
    .preferredColorScheme(.dark)
}
