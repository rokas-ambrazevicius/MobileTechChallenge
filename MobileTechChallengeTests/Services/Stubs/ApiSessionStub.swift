import Combine
import Foundation
@testable import MobileTechChallenge

final class ApiSessionStub: APISessionProviding {
    var shouldFail = false
    
    func execute<T>(_ requestProvider: ApiRequestable) -> AnyPublisher<T, Error> where T: Decodable {
        if !shouldFail, requestProvider.path == CurrencyLabelsRequest().path {
            guard let currencies = [currenciesStub] as? T
            else {
                return Fail(error: URLError(.resourceUnavailable))
                    .eraseToAnyPublisher()
            }
            
            return Just(currencies)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else if !shouldFail, requestProvider.path == TickersRequest(symbols: [""]).path {
            guard let tickers = tickersStub as? T
            else {
                return Fail(error: URLError(.resourceUnavailable))
                    .eraseToAnyPublisher()
            }
            
            return Just(tickers)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.cannotFindHost))
                .eraseToAnyPublisher()
        }
    }
}
