@testable import MobileTechChallenge

private let usdInfo = [
    Currency.CurrencyInfo.symbol("USD"),
    Currency.CurrencyInfo.label("US Dollar")
]

private let btcInfo = [
    Currency.CurrencyInfo.symbol("BTC"),
    Currency.CurrencyInfo.label("Bitcoin")
]

private let ethInfo = [
    Currency.CurrencyInfo.symbol("ETH"),
    Currency.CurrencyInfo.label("Ethereum")
]

let currenciesStub = [
    Currency(info: usdInfo),
    Currency(info: btcInfo),
    Currency(info: ethInfo)
]
