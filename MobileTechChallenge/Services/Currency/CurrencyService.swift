import Combine

protocol CurrencyServiceProviding {
    var currencies: ObservableValue<[Currency]> { get }
}

final class CurrencyService: CurrencyServiceProviding {
    typealias CurrencyResponseModel = [[Currency]]
    
    private let currencyLabelsProvider: CurrencyLabelsProviding
    private let networkMonitor: NetworkMonitoring
    
    private var cancellables: Set<AnyCancellable> = []
    
    private(set) var currencies = ObservableValue<[Currency]>(value: [Currency]())
    
    init(currencyLabelsProvider: CurrencyLabelsProviding, networkMonitor: NetworkMonitoring) {
        self.currencyLabelsProvider = currencyLabelsProvider
        self.networkMonitor = networkMonitor
        setup()
    }
    
    // MARK: - Setup -
    
    private func setup() {
        fetchCurrencies()
        setupObservers()
    }
    
    private func setupObservers() {
        networkMonitor.isAvailable.subscribe(self, shouldInit: false) { [weak self] isAvailable in
            guard let self = self,
                    isAvailable,
                    self.currencies.value.isEmpty
            else {
                return
            }
            
            self.fetchCurrencies()
        }
    }
    
    private func fetchCurrencies() {
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { completion in
            if case let .failure(error) = completion {
                // Log, display, or do whatever needs to be done
                print(error as Any)
            }
        }
        
        let valueHandler: (CurrencyResponseModel) -> Void = { [weak self] newCurrencies in
            self?.currencies.value = newCurrencies.flatMap { $0 }
        }
        
        currencyLabelsProvider.fetch()
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellables)
    }
}
