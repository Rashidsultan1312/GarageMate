import Foundation

enum AppFormatters {
    static let duration: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()

    private static var currencyFormatters: [CurrencyOption: NumberFormatter] = [:]

    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    static func currencyString(for value: Double, currency: CurrencyOption) -> String {
        let formatter: NumberFormatter

        if let cached = currencyFormatters[currency] {
            formatter = cached
        } else {
            let created = NumberFormatter()
            created.numberStyle = .currency
            created.currencyCode = currency.rawValue
            created.locale = Locale(identifier: currency.localeIdentifier)
            created.maximumFractionDigits = 2
            currencyFormatters[currency] = created
            formatter = created
        }

        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

extension Int {
    var asTimerString: String {
        AppFormatters.duration.string(from: TimeInterval(self)) ?? "00:00"
    }
}

extension Double {
    func asCurrencyString(_ currency: CurrencyOption) -> String {
        AppFormatters.currencyString(for: self, currency: currency)
    }
}
