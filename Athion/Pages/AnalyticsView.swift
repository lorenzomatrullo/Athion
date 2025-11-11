import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        ZStack {
            CustomBackgroundView()
            
            VStack(spacing: 8) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                Text("Analytics coming soon")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("We’re building insights to help you track progress.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
}

#Preview {
    AnalyticsView()
}
