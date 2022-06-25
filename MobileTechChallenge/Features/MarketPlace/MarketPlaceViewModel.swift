import Foundation
import Combine

protocol MarketPlaceViewModelProviding {
    var cellViewModels: ObservableValue<[MarketplaceCellViewModelProviding]> { get }
    var filter: ObservableValue<String> { get set }
    var isInternetAvailable: ObservableValue<Bool> { get set }
}

final class MarketPlaceViewModel: MarketPlaceViewModelProviding {
    private let tickersProvider: TickersProviding
    private let currencyService: CurrencyService
    private let generalFormatters: GeneralFormatters
    private let networkMonitor: NetworkMonitoring
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var tickers = [Ticker]()
    
    private(set)var cellViewModels = ObservableValue<[MarketplaceCellViewModelProviding]>(value: [MarketplaceCellViewModel]())
    
    var filter = ObservableValue<String>(value: "")
    var isInternetAvailable = ObservableValue<Bool>(value: false)
    
    init(tickersProvider: TickersProviding,
         currencyService: CurrencyService,
         generalFormatters: GeneralFormatters,
         networkMonitor: NetworkMonitoring) {
        self.tickersProvider = tickersProvider
        self.currencyService = currencyService
        self.generalFormatters = generalFormatters
        self.networkMonitor = networkMonitor
        setup()
    }
    
    // MARK: - Private -
    
    private func setup() {
        update()
        setupUpdates()
        setupObservers()
    }
    
    private func setupUpdates() {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] timer in
            guard let self = self,
                  self.networkMonitor.isAvailable.value
            else {
                return
            }
            
            self.update()
        }
    }
    
    private func setupObservers() {
        currencyService.currencies.subscribe(self, shouldInit: false) { [weak self] _ in
            self?.updateCellModels()
        }
        
        filter.subscribe(self, shouldInit: false) { [weak self] _ in
            self?.updateCellModels()
        }
        
        networkMonitor.isAvailable.subscribe(self, shouldInit: true) { [weak self] isAvailable in
            self?.isInternetAvailable.value = isAvailable
        }
    }
    
    private func update() {
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { completion in
            if case let .failure(error) = completion {
                // Log error, error count or whatever the policy
                print("🔥", error.localizedDescription)
            }
        }
        
        let valueHandler: ([Ticker]) -> Void = { [weak self] newTickers in
            self?.tickers = newTickers
            self?.updateCellModels()
        }
        
        tickersProvider.fetch()
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellableSet)
    }
    
    private func updateCellModels() {
        var models = [MarketplaceCellViewModel]()
        
        let filteredTickers = filterTickersIfNecessary()
        
        filteredTickers.forEach { item in
            let name = currencyService.currencies.value.first { $0.symbol == item.displaySymbol }?.label ?? ""
            
            let model = MarketplaceCellViewModel(
                ticker: item,
                name: name,
                generalFormatters: generalFormatters
            )
            models.append(model)
        }
        cellViewModels.value = models
    }
    
    private func filterTickersIfNecessary() -> [Ticker] {
        guard !filter.value.isEmpty else { return tickers }
        
        // Filter currencies containing search filter
        let filteredCurrencies = currencyService.currencies.value.filter { currency in
            guard let symbol = currency.symbol?.lowercased(),
                  let label = currency.label?.lowercased(),
                  symbol.contains(filter.value.lowercased()) || label.contains(filter.value.lowercased())
            else {
                return false
            }
            
            return true
        }
        
        // Filter tickers containing currencies
        let filteredTickers = tickers.filter { ticker in
            filteredCurrencies.contains { currency in
                guard let tickerSymbol = ticker.displaySymbol,
                      let currencySymbol = currency.symbol,
                      currencySymbol.contains(tickerSymbol)
                else {
                    return false
                }
                
                return true
            }
        }
        return filteredTickers
    }
}
