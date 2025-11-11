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
                    Label {
                        Text("Profile")
                    } icon: {
                        Image(systemName: isSignedIn ? "person" : "person.badge.shield.exclamationmark")
                    }
                }
        }
        .accentColor(.white)
    }
}

#Preview {
    AppPreview()
        .preferredColorScheme(.dark)
}
