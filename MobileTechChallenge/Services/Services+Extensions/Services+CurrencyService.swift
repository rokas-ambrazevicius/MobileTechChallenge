import Foundation

extension Services {
    static let currencyService = CurrencyService(
        currencyLabelsProvider: Services.currencyLabelsProvider,
        networkMonitor: Services.networkMonitor
    )
}
