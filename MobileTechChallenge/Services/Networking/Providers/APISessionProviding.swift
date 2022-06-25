import Combine

protocol APISessionProviding {
    func execute<T: Decodable>(_ requestProvider: ApiRequestable) -> AnyPublisher<T, Error>
}
