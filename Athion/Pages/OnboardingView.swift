import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    var onContinue: () -> Void = {}
    @State private var showSkipConfirm: Bool = false
    @AppStorage("isSignedIn") private var isSignedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Welcome to Athion")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Sign in with your Apple ID to sync workouts and progress securely in iCloud.")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.75))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                        .padding(.top, 40)
                        
                        // Benefits card
                        VStack(alignment: .leading, spacing: 14) {
                            HStack(spacing: 10) {
                                Image(systemName: "icloud")
                                    .foregroundColor(.white)
                                Text("Cloud sync across devices")
                                    .foregroundColor(.white.opacity(0.9))
                                    .font(.headline)
                                Spacer()
                            }
                            
                            Divider().overlay(Color.white.opacity(0.12))
                                .padding(.horizontal, 8)
                            
                            HStack(spacing: 10) {
                                Image(systemName: "lock.shield")
                                    .foregroundColor(.white)
                                Text("Private by design")
                                    .foregroundColor(.white.opacity(0.9))
                                    .font(.headline)
                                Spacer()
                            }
                            
                            Divider().overlay(Color.white.opacity(0.12))
                                .padding(.horizontal, 8)
                            
                            HStack(spacing: 10) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .foregroundColor(.white)
                                Text("Automatic backup of workouts")
                                    .foregroundColor(.white.opacity(0.9))
                                    .font(.headline)
                                Spacer()
                            }
                        }
                        .glassCard(cornerRadius: 24, padding: 16)
                        .padding(.horizontal, 20)
                        
                        // Native Sign in with Apple button (styled)
                        SignInWithAppleButton(.signIn) { request in
                            request.requestedScopes = []
                        } onCompletion: { result in
                            switch result {
                            case .success:
                                Task { @MainActor in
                                    isSignedIn = true
                                    onContinue()
                                }
                            case .failure:
                                break
                            }
                        }
                        .signInWithAppleButtonStyle(.white)
                        .frame(height: 50)
                        .cornerRadius(25)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 24)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip") {
                        showSkipConfirm = true
                    }
                    .confirmationDialog(
                        "Continue without signing in?",
                        isPresented: $showSkipConfirm,
                        titleVisibility: .visible
                    ) {
                        Button("Continue") { isSignedIn = false; onContinue() }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Your data will be stored only on this device and won’t sync across devices. You can sign in later from the profile tab.")
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
        .preferredColorScheme(.dark)
}
