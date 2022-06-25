import Foundation

struct TickersRequest: ApiRequestable {
    let method: HTTPMethod = .get
    let path = ApiConstants.Path.tickers
    var parameters: [String: String]?
    
    init(symbols: [String]?) {
        guard let symbols = symbols else { return }
        
        let joinedSymbols = symbols.joined(separator: ",")
        parameters = ["symbols": joinedSymbols]
    }
}
