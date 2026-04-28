import SwiftUI

struct MainTabView: View {
    @ObservedObject var jobsViewModel: JobsViewModel
    @ObservedObject var scanViewModel: ScanViewModel
    @ObservedObject var garageViewModel: GarageViewModel
    @ObservedObject var settingsViewModel: AppSettingsViewModel

    var body: some View {
        TabView {
            NavigationStack {
                JobsView(viewModel: jobsViewModel)
            }
            .tabItem {
                Label("Jobs", systemImage: "briefcase.fill")
            }

            NavigationStack {
                ScanView(viewModel: scanViewModel)
            }
            .tabItem {
                Label("Scan", systemImage: "waveform.path.ecg")
            }

            NavigationStack {
                GarageView(viewModel: garageViewModel)
            }
            .tabItem {
                Label("Garage", systemImage: "building.2.fill")
            }
        }
        .tint(AppTheme.accent)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)
        .environmentObject(settingsViewModel)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(
            jobsViewModel: JobsViewModel(),
            scanViewModel: ScanViewModel(),
            garageViewModel: {
                let model = GarageViewModel()
                model.sync(from: MockData.jobs)
                return model
            }(),
            settingsViewModel: AppSettingsViewModel()
        )
    }
}
