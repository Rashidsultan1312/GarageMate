import SwiftUI

private struct OnboardingSlide: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let symbol: String
    let color: Color
}

struct OnboardingView: View {
    let onFinish: () -> Void

    @State private var currentPage = 0

    private let slides: [OnboardingSlide] = [
        OnboardingSlide(
            title: "Diagnose Faster",
            subtitle: "Guided checklists keep every diagnostic step clear and repeatable.",
            symbol: "checklist.checked",
            color: AppTheme.accent
        ),
        OnboardingSlide(
            title: "Decode OBD2 Instantly",
            subtitle: "Find code meanings, likely causes, and practical recommendations near the car.",
            symbol: "waveform.path.ecg",
            color: AppTheme.warning
        ),
        OnboardingSlide(
            title: "Show Results Clearly",
            subtitle: "Track time, parts, and before/after photos to look professional with clients.",
            symbol: "camera.metering.matrix",
            color: AppTheme.success
        )
    ]

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 18) {
                HStack {
                    Spacer()
                    if currentPage < slides.count - 1 {
                        Button("Skip") {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentPage = slides.count - 1
                            }
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white.opacity(0.85))
                    }
                }

                TabView(selection: $currentPage) {
                    ForEach(Array(slides.enumerated()), id: \.element.id) { index, slide in
                        onboardingCard(slide)
                            .tag(index)
                            .padding(.horizontal, 4)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack(spacing: 8) {
                    ForEach(slides.indices, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? Color.white : Color.white.opacity(0.35))
                            .frame(width: index == currentPage ? 26 : 10, height: 10)
                    }
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: currentPage)

                Button(action: nextStep) {
                    Text(currentPage == slides.count - 1 ? "Enter Garage Mate" : "Next")
                        .font(.headline.weight(.bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AppTheme.accent)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(22)
        }
    }

    @ViewBuilder
    private func onboardingCard(_ slide: OnboardingSlide) -> some View {
        FrostedCard {
            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(slide.color.opacity(0.18))
                        .frame(height: 170)

                    Image(systemName: slide.symbol)
                        .font(.system(size: 74, weight: .medium))
                        .foregroundColor(slide.color)
                }

                Text(slide.title)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundColor(.white)

                Text(slide.subtitle)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.84))
            }
        }
    }

    private func nextStep() {
        if currentPage < slides.count - 1 {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                currentPage += 1
            }
        } else {
            onFinish()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView {}
    }
}
