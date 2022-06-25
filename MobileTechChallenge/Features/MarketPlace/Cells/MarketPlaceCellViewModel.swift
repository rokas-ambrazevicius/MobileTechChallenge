import Foundation
import UIKit

protocol MarketplaceCellViewModelProviding {
    var name: String { get }
    var dailyChange: String? { get }
    var image: UIImage? { get }
    var price: String? { get }
    var symbol: String? { get }
    
    func dailyChangeLabelColor() -> UIColor
}

struct MarketplaceCellViewModel: MarketplaceCellViewModelProviding {
    private let ticker: Ticker
    private let generalFormatters: GeneralFormatters
    
    private let positiveColor = UIColor.systemGreen
    private let neutralColor = UIColor.tertiaryLabel
    private let negativeColor = UIColor.red
    
    var name: String
    
    var dailyChange: String? {
        guard let change = ticker.dailyChangeRelative else { return nil }
        return generalFormatters.dailyChange(change)
    }
    
    var image: UIImage? {
        return ticker.image
    }
    
    var price: String? {
        guard let lastPrice = ticker.lastPrice else { return nil }
        return generalFormatters.price(lastPrice)
    }
    
    var symbol: String? {
        return ticker.displaySymbol
    }
    
    init(ticker: Ticker,
         name: String,
         generalFormatters: GeneralFormatters) {
        self.ticker = ticker
        self.name = name
        self.generalFormatters = generalFormatters
    }
    
    func dailyChangeLabelColor() -> UIColor {
        guard let dailyChange = ticker.dailyChangeRelative else { return neutralColor }
        
        switch dailyChange {
        case ..<0:
            return negativeColor
        case 0:
            return neutralColor
        default:
            return positiveColor
        }
    }
}
