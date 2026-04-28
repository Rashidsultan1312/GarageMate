import Foundation

enum CurrencyOption: String, CaseIterable, Codable, Identifiable {
    case usd = "USD"
    case eur = "EUR"
    case rub = "RUB"
    case gbp = "GBP"
    case jpy = "JPY"
    case cny = "CNY"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .usd:
            return "US Dollar (USD)"
        case .eur:
            return "Euro (EUR)"
        case .rub:
            return "Russian Ruble (RUB)"
        case .gbp:
            return "British Pound (GBP)"
        case .jpy:
            return "Japanese Yen (JPY)"
        case .cny:
            return "Chinese Yuan (CNY)"
        }
    }

    var localeIdentifier: String {
        switch self {
        case .usd:
            return "en_US"
        case .eur:
            return "de_DE"
        case .rub:
            return "ru_RU"
        case .gbp:
            return "en_GB"
        case .jpy:
            return "ja_JP"
        case .cny:
            return "zh_CN"
        }
    }
}
