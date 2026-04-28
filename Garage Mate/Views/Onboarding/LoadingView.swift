import SwiftUI

struct LoadingView: View {
    @State private var spin = false
    @State private var pulse = false

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(AppTheme.accent.opacity(0.2))
                        .frame(width: 130, height: 130)
                        .scaleEffect(pulse ? 1.06 : 0.92)

                    Circle()
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        .frame(width: 130, height: 130)

                    Image(systemName: "wrench.and.screwdriver.fill")
                        .font(.system(size: 46, weight: .bold))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(spin ? 360 : 0))
                }

                VStack(spacing: 8) {
                    Text("Garage Mate")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundColor(.white)

                    Text("Preparing your mechanic workspace...")
                        .font(.callout)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(28)
        }
        .onAppear {
            withAnimation(.linear(duration: 2.4).repeatForever(autoreverses: false)) {
                spin = true
            }
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
