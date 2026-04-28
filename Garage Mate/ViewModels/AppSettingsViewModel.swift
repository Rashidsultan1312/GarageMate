import Foundation

@MainActor
final class AppSettingsViewModel: ObservableObject {
    @Published var selectedCurrency: CurrencyOption {
        didSet {
            saveCurrency()
        }
    }

    var appVersionDescription: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "Version \(version) (\(build))"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        if let rawValue = defaults.string(forKey: AppStorageKeys.currencyCode),
           let currency = CurrencyOption(rawValue: rawValue) {
            selectedCurrency = currency
        } else {
            selectedCurrency = .usd
        }
    }

    private func saveCurrency() {
        defaults.set(selectedCurrency.rawValue, forKey: AppStorageKeys.currencyCode)
    }
}
