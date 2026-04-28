import SwiftUI

@MainActor
final class AppFlowViewModel: ObservableObject {
    @Published var showsLoading = true
    @AppStorage(AppStorageKeys.onboardingSeen) private var hasSeenOnboarding = false

    var shouldShowOnboarding: Bool {
        !hasSeenOnboarding
    }

    func start() {
        guard showsLoading else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { [weak self] in
            withAnimation(.easeInOut(duration: 0.35)) {
                self?.showsLoading = false
            }
        }
    }

    func completeOnboarding() {
        hasSeenOnboarding = true
    }
}
