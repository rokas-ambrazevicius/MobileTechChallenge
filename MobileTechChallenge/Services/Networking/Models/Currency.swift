import Foundation

struct Currency: Decodable {
    private var info = [CurrencyInfo]()
    
    var symbol: String? {
        let symbol = info.first { item in
            if case .symbol = item {
                return true
            } else {
                return false
            }
        }
        return symbol?.valueToString()
    }
    
    var label: String? {
        let label = info.first { item in
            if case .label = item {
                return true
            } else {
                return false
            }
        }
        return label?.valueToString()
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        var values = [String]()
        
        while !container.isAtEnd {
            if let text = try? container.decode(String.self) {
                values.append(text)
            }
        }
        
        values.enumerated().forEach { (index, value) in
            info.append(CurrencyInfo(index: index, value: value))
        }
    }
    
    init(info: [CurrencyInfo]) {
        self.info = info
    }
}

extension Currency {
    enum CurrencyInfo {
        case symbol(String)
        case label(String)
        case unknown
        
        init(index: Int, value: String) {
            switch index {
            case 0:
                self = .symbol(value)
            case 1:
                self = .label(value)
            default:
                self = .unknown
            }
        }
        
        func valueToString() -> String {
            switch self {
            case .symbol(let value), .label(let value):
                return value
            case .unknown:
                return ""
            }
        }
    }
}
