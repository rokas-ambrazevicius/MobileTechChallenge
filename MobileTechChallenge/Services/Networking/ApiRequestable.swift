import Foundation

protocol ApiRequestable {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String]? { get }

    func asURLRequest() -> URLRequest
}

enum HTTPMethod {
    case get
    case post

    var value: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

extension ApiRequestable {
    func asURLRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = ApiConstants.scheme
        components.host = ApiConstants.baseURLString
        components.path = path
        components.queryItems = parameters?.compactMap { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = components.url else {
            preconditionFailure("Can't create URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        
        return request
    }
}
