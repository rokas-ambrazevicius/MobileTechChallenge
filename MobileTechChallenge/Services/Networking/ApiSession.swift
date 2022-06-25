import Foundation
import Combine

struct ApiSession: APISessionProviding {
    private let decoder = JSONDecoder()
    private let apiQueue = DispatchQueue(label: "APISession", qos: .default, attributes: .concurrent)
    
    func execute<T>(_ requestProvider: ApiRequestable) -> AnyPublisher<T, Error> where T: Decodable {
        return URLSession.shared.dataTaskPublisher(for: requestProvider.asURLRequest())
            .receive(on: apiQueue)
            .tryMap { element -> Data in
                
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                if httpResponse.statusCode == 401 {
                    throw URLError(.userAuthenticationRequired)
                }
                return element.data
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
