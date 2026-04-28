import SwiftUI

struct AppBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.backgroundStart, AppTheme.backgroundEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(AppTheme.accent.opacity(0.18))
                .frame(width: 280, height: 280)
                .blur(radius: 50)
                .offset(x: 130, y: -260)

            Circle()
                .fill(AppTheme.success.opacity(0.14))
                .frame(width: 240, height: 240)
                .blur(radius: 60)
                .offset(x: -160, y: 240)
        }
        .ignoresSafeArea()
    }
}

struct AppBackground_Previews: PreviewProvider {
    static var previews: some View {
        AppBackground()
    }
}
