import Combine

protocol CurrencyLabelsProviding {
    func fetch() -> AnyPublisher<CurrencyService.CurrencyResponseModel, Error>
}

struct CurrencyLabelsProvider: CurrencyLabelsProviding {
    private let request = CurrencyLabelsRequest()
    private let apiSession: APISessionProviding
    
    init(apiSession: APISessionProviding) {
        self.apiSession = apiSession
    }
    
    func fetch() -> AnyPublisher<CurrencyService.CurrencyResponseModel, Error> {
        apiSession.execute(request)
            .tryCatch { _ -> AnyPublisher<CurrencyService.CurrencyResponseModel, Error> in
                return apiSession.execute(request)
            }
            .eraseToAnyPublisher()
    }
}
