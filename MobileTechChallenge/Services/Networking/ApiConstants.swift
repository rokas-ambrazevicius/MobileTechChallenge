import Foundation

struct ApiConstants {
    static let scheme = "https"
    static let baseURLString = "api-pub.bitfinex.com"
    
    struct Path {
        static let tickers = "/v2/tickers"
        static let currencyLabels = "/v2/conf/pub:map:currency:label"
    }
}
