@testable import MobileTechChallenge

private let btcInfo = [
    Ticker.TickerInfo.dailyChangeRelative(10),
    Ticker.TickerInfo.symbol("tBTCUSD"),
    Ticker.TickerInfo.lastPrice(49999.1)
]

private let ethInfo = [
    Ticker.TickerInfo.dailyChangeRelative(5),
    Ticker.TickerInfo.symbol("tETHUSD"),
    Ticker.TickerInfo.lastPrice(1101.1)
]

let tickersStub = [
    Ticker(info: btcInfo),
    Ticker(info: ethInfo)
]
