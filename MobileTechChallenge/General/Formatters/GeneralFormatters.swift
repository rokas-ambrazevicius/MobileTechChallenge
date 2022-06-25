import Foundation

final class GeneralFormatters {
    func dailyChange(_ value: Double, locale: Locale? = Locale(identifier: "en_US")) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.positivePrefix = "+"
        numberFormatter.locale = locale
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(for: value)
    }
    
    // Locale should be taken from user settings
    func price(_ value: Double, locale: Locale? = Locale(identifier: "en_US")) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        
        switch value {
        case ..<1:
            numberFormatter.maximumFractionDigits = 6
        default:
            numberFormatter.maximumFractionDigits = 2
        }
        
        return numberFormatter.string(for: value)
    }
}
