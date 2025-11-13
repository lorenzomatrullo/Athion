import SwiftUI
import UIKit

struct AppPreview: View {
    @AppStorage("isSignedIn") private var isSignedIn: Bool = false
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        appearance.shadowColor = .clear
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // Ensure cursor/selection handles for text inputs are white across the app
        UITextField.appearance().tintColor = .white
        UITextView.appearance().tintColor = .white
    }
    
    var body: some View {
        TabView {
            SessionView()
                .tabItem {
                    Label("Session", systemImage: "dumbbell.fill")
                }
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.xaxis")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: isSignedIn ? "person.fill" : "person.badge.shield.exclamationmark.fill")
                }
        }
        .accentColor(.white)
        .tint(.white)
        .keyboardDismissToolbar()
    }
}

#Preview {
    AppPreview()
        .preferredColorScheme(.dark)
}
