import Foundation

extension Services {
    static let currencyLabelsProvider: CurrencyLabelsProvider = CurrencyLabelsProvider(apiSession: Services.apiSession)
}
