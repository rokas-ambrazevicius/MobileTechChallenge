import XCTest
@testable import MobileTechChallenge

final class MarketplaceViewModelTests: XCTestCase {
    func testSuccessfulInitialState() {
        let tickersProvider = TickersProvider(apiSession: ServicesMock.apiSession, symbols: ["test"])
        
        let currencyLabelsProvider = CurrencyLabelsProvider(apiSession: ServicesMock.apiSession)
        let currencyService = CurrencyService(
            currencyLabelsProvider: currencyLabelsProvider,
            networkMonitor: ServicesMock.networkMonitor
        )
        
        let model = MarketPlaceViewModel(
            tickersProvider: tickersProvider,
            currencyService: currencyService,
            generalFormatters: Services.generalFormatters,
            networkMonitor: ServicesMock.networkMonitor
        )
        
        XCTAssertTrue(model.cellViewModels.value.count == tickersStub.count)
        XCTAssertTrue(model.isInternetAvailable.value == true)
        XCTAssertTrue(model.filter.value == "")
    }
    
    func testFailureInitialState() {
        // No internet

        let apiService = ApiSessionStub()
        apiService.shouldFail = true
        
        let tickersProvider = TickersProvider(apiSession: apiService, symbols: ["test"])
        
        let currencyLabelsProvider = CurrencyLabelsProvider(apiSession: apiService)
        
        let networkMonitor = NetworkMonitorStub()
        networkMonitor.isAvailable.value = false
        networkMonitor.isCellularUsed.value = false
        networkMonitor.isWifiUsed.value = false
        
        let currencyService = CurrencyService(
            currencyLabelsProvider: currencyLabelsProvider,
            networkMonitor: networkMonitor
        )
        
        let model = MarketPlaceViewModel(
            tickersProvider: tickersProvider,
            currencyService: currencyService,
            generalFormatters: Services.generalFormatters,
            networkMonitor: networkMonitor
        )
        
        XCTAssertTrue(model.cellViewModels.value.count == 0)
        XCTAssertTrue(model.isInternetAvailable.value == false)
        XCTAssertTrue(model.filter.value == "")
        
        // Recover internet

        apiService.shouldFail = false
        networkMonitor.isAvailable.value = true
        networkMonitor.isCellularUsed.value = true
        
        let result = XCTWaiter.wait(
            for: [
                expectation(description: "Test update after 5 seconds")
            ],
            timeout: 6.0
        )
        
        if result == XCTWaiter.Result.timedOut {
            XCTAssertTrue(model.cellViewModels.value.count == tickersStub.count)
            XCTAssertTrue(model.isInternetAvailable.value == true)
            XCTAssertTrue(model.filter.value == "")
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testFiltering() {
        let tickersProvider = TickersProvider(apiSession: ServicesMock.apiSession, symbols: ["test"])
        
        let currencyLabelsProvider = CurrencyLabelsProvider(apiSession: ServicesMock.apiSession)
        let currencyService = CurrencyService(
            currencyLabelsProvider: currencyLabelsProvider,
            networkMonitor: ServicesMock.networkMonitor
        )
        
        let model = MarketPlaceViewModel(
            tickersProvider: tickersProvider,
            currencyService: currencyService,
            generalFormatters: Services.generalFormatters,
            networkMonitor: ServicesMock.networkMonitor
        )
        
        XCTAssertTrue(model.cellViewModels.value.count == tickersStub.count)
        XCTAssertTrue(model.isInternetAvailable.value == true)
        XCTAssertTrue(model.filter.value == "")
        
        model.filter.value = "Bitcoin"
        
        XCTAssertTrue(model.cellViewModels.value.count == 1)
        XCTAssertTrue(model.filter.value == "Bitcoin")
    }
}

