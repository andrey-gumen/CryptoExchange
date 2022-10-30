import UIKit

protocol CurrencyDetailsRouterInput {
    func moveBack()
}

final class CurrencyDetailsRouter {
    
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController, currencyId: String) {
        self.navigationController = navigationController
        
        let view = DefaultCurrencyDetailsView()
        let presenter = DefaultCurrencyDetailsPresenter(id: currencyId, view: view)
        view.presenter = presenter
        
        navigationController.pushViewController(view, animated: true)
    }
    
    func moveBack() {
        navigationController.popViewController(animated: true)
    }
    
}
