
import SwiftUI

struct ContentView: View {
    enum PreviewRoute {
        case loading
        case onboarding
        case main
    }

    @StateObject private var flowViewModel = AppFlowViewModel()
    @StateObject private var jobsViewModel = JobsViewModel()
    @StateObject private var scanViewModel = ScanViewModel()
    @StateObject private var garageViewModel = GarageViewModel()
    @StateObject private var settingsViewModel = AppSettingsViewModel()
    @Environment(\.scenePhase) private var scenePhase

    private let previewRoute: PreviewRoute?

    init(previewRoute: PreviewRoute? = nil) {
        self.previewRoute = previewRoute
    }

    var body: some View {
        Group {
            if let previewRoute {
                previewContent(for: previewRoute)
            } else {
                liveFlow
            }
        }
        .environmentObject(settingsViewModel)
        .task {
            guard previewRoute == nil else { return }
            flowViewModel.start()
            garageViewModel.sync(from: jobsViewModel.jobs)
        }
        .onChange(of: jobsViewModel.jobs) { jobs in
            garageViewModel.sync(from: jobs)
        }
        .onChange(of: scenePhase) { phase in
            guard previewRoute == nil else { return }
            if phase == .inactive || phase == .background {
                jobsViewModel.persistNow()
            }
        }
    }

    @ViewBuilder
    private var liveFlow: some View {
        if flowViewModel.showsLoading {
            LoadingView()
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
        } else if flowViewModel.shouldShowOnboarding {
            OnboardingView {
                flowViewModel.completeOnboarding()
            }
            .transition(.move(edge: .trailing).combined(with: .opacity))
        } else {
            MainTabView(
                jobsViewModel: jobsViewModel,
                scanViewModel: scanViewModel,
                garageViewModel: garageViewModel,
                settingsViewModel: settingsViewModel
            )
        }
    }

    @ViewBuilder
    private func previewContent(for route: PreviewRoute) -> some View {
        switch route {
        case .loading:
            LoadingView()
        case .onboarding:
            OnboardingView {}
        case .main:
            MainTabView(
                jobsViewModel: jobsViewModel,
                scanViewModel: scanViewModel,
                garageViewModel: garageViewModel,
                settingsViewModel: settingsViewModel
            )
            .onAppear {
                garageViewModel.sync(from: jobsViewModel.jobs)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(previewRoute: .main)
                .previewDisplayName("Main App")

            ContentView(previewRoute: .onboarding)
                .previewDisplayName("Onboarding")

            ContentView(previewRoute: .loading)
                .previewDisplayName("Loading")
        }
    }
}
