import Foundation

struct CurrencyLabelsRequest: ApiRequestable {
    let method: HTTPMethod = .get
    let path = ApiConstants.Path.currencyLabels
    var parameters: [String: String]?
}
