import SwiftUI
import UIKit

#if canImport(UIKit)
enum CardStyleHelpers {
    static var primaryText: Color { .white.opacity(0.9) }
    static var secondaryText: Color { .white.opacity(0.7) }
    
    static func headerBackground(for colorScheme: ColorScheme) -> some View {
        // Keep the header airy so it doesn't look opaque on top.
        // We avoid stacking another material here and use a subtle highlight only.
        LinearGradient(
            colors: [
                .white.opacity(colorScheme == .dark ? 0.08 : 0.12),
                .clear
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .blendMode(.screen)
    }
}

// Shape that rounds only the top corners - avoids square artifacts in header background
struct TopRoundedCorners: Shape {
    var radius: CGFloat = 24
    
    func path(in rect: CGRect) -> Path {
        let bezier = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(bezier.cgPath)
    }
}

extension View {
    func cardStyle(
        cornerRadius: CGFloat = 24
    ) -> some View {
        self.glassCard(cornerRadius: cornerRadius, padding: 0)
    }
}
#endif

#if canImport(SwiftUI)
// MARK: - New Card Style API
struct CardBackground: View {
    var corner: CGFloat = 20
    var body: some View {
        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .fill(
                LinearGradient(colors: [
                    Color.white.opacity(0.10),
                    Color.white.opacity(0.04)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .background(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .fill(Color.white.opacity(0.02))
            )
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(
                        LinearGradient(colors: [
                            Color.white.opacity(0.35),
                            Color.white.opacity(0.10)
                        ], startPoint: .topLeading, endPoint: .bottomTrailing),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.45), radius: 12, x: 0, y: 10)
            .shadow(color: .black.opacity(0.25), radius: 4,  x: 0, y: 1)
    }
}

extension View {
    func glassCard(
        cornerRadius: CGFloat = 20,
        padding: CGFloat = 14
    ) -> some View {
        self
            .padding(padding)
            .background(CardBackground(corner: cornerRadius))
    }
    
    func solidCard(
        cornerRadius: CGFloat = 20,
        padding: CGFloat = 14,
        top: Color = Color(#colorLiteral(red: 0.13, green: 0.13, blue: 0.17, alpha: 1)),
        bottom: Color = Color(#colorLiteral(red: 0.06, green: 0.07, blue: 0.10, alpha: 1))
    ) -> some View {
        self
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(LinearGradient(colors: [top, bottom],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.45), radius: 12, x: 0, y: 10)
            .shadow(color: .black.opacity(0.25), radius: 4,  x: 0, y: 1)
    }
}
#endif
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(spacing: 24) {
            Text("Glassy Card")
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 300, height: 160)
                .glassCard(cornerRadius: 24)
            
            Text("Solid Card")
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 300, height: 160)
                .solidCard(cornerRadius: 24)
        }
    }
}
