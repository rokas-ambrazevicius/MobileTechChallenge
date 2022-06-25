import Combine

protocol TickersProviding {
    func fetch() -> AnyPublisher<[Ticker], Error>
}

struct TickersProvider: TickersProviding {
    private let request: TickersRequest
    private let apiSession: APISessionProviding
    
    static var defaultUSDPairs: [String] {
        return [
            "tBTCUSD",
            "tETHUSD",
            "tCHSB:USD",
            "tLTCUSD",
            "tXRPUSD",
            "tDSHUSD",
            "tRRTUSD",
            "tEOSUSD",
            "tSANUSD",
            "tDATUSD",
            "tSNTUSD",
            "tDOGE:USD",
            "tLUNA:USD",
            "tMATIC:USD",
            "tNEXO:USD",
            "tOCEAN:USD",
            "tBEST:USD",
            "tAAVE:USD",
            "tPLUUSD",
            "tFILUSD"
        ]
    }
    
    static var defaultCurrencySymbol = "USD"
    
    init(apiSession: APISessionProviding, symbols: [String]) {
        self.apiSession = apiSession
        self.request = TickersRequest(symbols: symbols)
    }
    
    func fetch() -> AnyPublisher<[Ticker], Error> {
        apiSession.execute(request)
            .tryCatch { _ -> AnyPublisher<[Ticker], Error> in
                return apiSession.execute(request)
            }
            .eraseToAnyPublisher()
    }
}
