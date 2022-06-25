import UIKit

final class AppCoordinator {
    let uiWindow: UIWindow?
    
    init(uiWindow: UIWindow) {
        self.uiWindow = uiWindow
    }
    
    func start() {
        let tickersProvider = TickersProvider(
            apiSession: Services.apiSession,
            symbols: TickersProvider.defaultUSDPairs
        )
        
        let marketplaceViewModel = MarketPlaceViewModel(
            tickersProvider: tickersProvider,
            currencyService: Services.currencyService,
            generalFormatters: Services.generalFormatters,
            networkMonitor: Services.networkMonitor
        )
        let viewController = MarketPlaceViewController.instantiate(
            viewModel: marketplaceViewModel
        )
        
        let navigationViewController = UINavigationController(rootViewController: viewController)
        
        uiWindow?.rootViewController = navigationViewController
        uiWindow?.makeKeyAndVisible()
    }
}
