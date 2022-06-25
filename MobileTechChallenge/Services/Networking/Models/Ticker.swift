import Foundation
import UIKit

struct Ticker: Decodable {
    private let symbolJoiningChars: Set<Character> = [":"]
    private let noImageName = "noImage"
    private var info = [TickerInfo]()
    
    var dailyChangeRelative: Double? {
        let change = info.first { item in
            if case .dailyChangeRelative = item {
                return true
            } else {
                return false
            }
        }
        return change?.doubleValue()
    }
    
    // Could load image from cache, download from internet
    var image: UIImage? {
        guard let symbol = displaySymbol else { return nil }
        return UIImage(named: symbol)
    }
    
    var lastPrice: Double? {
        let price = info.first { item in
            if case .lastPrice = item {
                return true
            } else {
                return false
            }
        }
        return price?.doubleValue()
    }
    
    /// Formats token fiat pair to token symbol
    var displaySymbol: String? {
        let symbol = info.first { item in
            if case .symbol = item {
                return true
            } else {
                return false
            }
        }
        guard var formattedSymbol = symbol?.stringValue() else { return nil }
        
        if let range = formattedSymbol.range(of: TickersProvider.defaultCurrencySymbol) {
            formattedSymbol.removeSubrange(range)
        }
        formattedSymbol = String(formattedSymbol.dropFirst())
        formattedSymbol.removeAll{ symbolJoiningChars.contains($0) }
        return formattedSymbol
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        var values = [Any]()
        
        while !container.isAtEnd {
            if let text = try? container.decode(String.self) {
                values.append(text)
            } else if let integer = try? container.decode(Double.self) {
                values.append(integer)
            }
        }
        
        values.enumerated().forEach { (index, value) in
            info.append(TickerInfo(index: index, value: value))
        }
    }
    
    init(info: [TickerInfo]) {
        self.info = info
    }
}

extension Ticker {
    enum TickerInfo {
        case symbol(String)
        case bid(Double)
        case bidSize(Double)
        case ask(Double)
        case askSize(Double)
        case dailyChange(Double)
        case dailyChangeRelative(Double)
        case lastPrice(Double)
        case volume(Double)
        case high(Double)
        case low(Double)
        case unknown
        
        init(index: Int, value: Any) {
            switch index {
            case 0:
                guard let text = value as? String
                else {
                    self = .unknown
                    return
                }
                self = .symbol(text)
            case 1:
                guard let number = value as? Double
                else {
                    self = .unknown
                    return
                }
                self = .bid(number)
            case 2:
                guard let number = value as? Double
                else {
                    self = .unknown
                    return
                }
                self = .bidSize(number)
            case 3:
                guard let number = value as? Double
                else {
                    self = .unknown
                    return
                }
                self = .ask(number)
            case 4:
                guard let number = value as? Double
                else {
                    self = .unknown
                    return
                }
                self = .askSize(number)
            case 5:
                guard let number = value as? Double
                else {
                    self = .unknown
                    return
                }
                self = .dailyChange(number)
            case 6:
                guard let number = value as? Double
                else {
                    self = .unknown
                    return
                }
                self = .dailyChangeRelative(number)
            case 7:
                guard let number = value as? Double
                else {
                    self = .unknown
                    return
                }
                self = .lastPrice(number)
            case 8:
                guard let number = value as? Double
                else {
                    self = .unknown
                    return
                }
                self = .volume(number)
            case 9:
                guard let number = value as? Double
                else {
                    self = .unknown
                    return
                }
                self = .high(number)
            case 10:
                guard let number = value as? Double
                else {
                    self = .unknown
                    return
                }
                self = .low(number)
            default:
                self = .unknown
            }
        }
        
        func doubleValue() -> Double? {
            switch self {
            case .bid(let value), .bidSize(let value), .ask(let value), .askSize(let value), .dailyChange(let value),
                    .dailyChangeRelative(let value), .lastPrice(let value), .volume(let value), .high(let value),
                    .low(let value):
                return value
            default:
                return nil
            }
        }
        
        func stringValue() -> String? {
            switch self {
            case .symbol(let value):
                return value
            default:
                return nil
            }
        }
    }
}
