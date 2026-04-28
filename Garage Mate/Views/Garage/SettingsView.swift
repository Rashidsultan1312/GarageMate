import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settingsViewModel: AppSettingsViewModel

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    FrostedCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Currency")
                                .font(.headline.weight(.bold))
                                .foregroundColor(.white)

                            ForEach(CurrencyOption.allCases) { currency in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        settingsViewModel.selectedCurrency = currency
                                    }
                                } label: {
                                    HStack {
                                        Text(currency.displayName)
                                            .foregroundColor(.white.opacity(0.9))
                                        Spacer()
                                        if settingsViewModel.selectedCurrency == currency {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(AppTheme.success)
                                        } else {
                                            Image(systemName: "circle")
                                                .foregroundColor(.white.opacity(0.45))
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    FrostedCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Release Info")
                                .font(.headline.weight(.bold))
                                .foregroundColor(.white)

                            Text(settingsViewModel.appVersionDescription)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.85))

                            Text("Data is stored locally on this device for reliable day-to-day use.")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(AppSettingsViewModel())
        }
    }
}
