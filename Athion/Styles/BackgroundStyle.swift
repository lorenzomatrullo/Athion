import SwiftUI
import UIKit

struct CustomBackgroundView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            LinearGradient(
                colors: [
                    .black,
                    .white.opacity(0.2),
                    .black,
                    .white.opacity(0.05),
                    .black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .blendMode(.screen)
            .ignoresSafeArea()
            
            RadialGradient(
                colors: [
                    .white.opacity(0.25),
                    .black.opacity(0.2),
                    .black
                ],
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .blendMode(.screen)
            .ignoresSafeArea()
        }
    }
}

private struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

#Preview {
    CustomBackgroundView()
}
