import SwiftUI
import AuthenticationServices

struct ProfileView: View {
    @AppStorage("isSignedIn") private var isSignedIn: Bool = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackgroundView()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // ACCOUNT
                        if !isSignedIn {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .foregroundColor(.white)
                                    Text("Sign in to sync and back up")
                                        .foregroundColor(.white.opacity(0.9))
                                        .font(.headline)
                                    Spacer()
                                }
                                
                                Text("Set up your account to automatically back up your workouts and keep your devices in sync.")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                                
                                SignInWithAppleButton(.signIn) { _ in
                                    // configure later
                                } onCompletion: { _ in
                                    // handle later
                                }
                                .signInWithAppleButtonStyle(.white)
                                .frame(height: 50)
                                .cornerRadius(25)
                            }
                            .glassCard(cornerRadius: 20, padding: 16)
                            .padding(.horizontal, 16)
                        }
                        
                        // FEEDBACK
                        Text("Feedback")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                        
                        Button(action: { /* wired later */ }) {
                            HStack(spacing: 10) {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                Text("Send Feedback")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .solidCard(cornerRadius: 18, padding: 0)
                        }
                        .padding(.horizontal, 16)
                        
                        Spacer(minLength: 12)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ProfileView()
}
