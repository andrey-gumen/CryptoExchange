import UIKit

protocol CurrencyListRouterInput {
    func moveToDetailsScreen(for id: String)
}

final class CurrencyListRouter: CurrencyListRouterInput {
    
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let view = DefaultCurrencyListView()
        let presenter = DefaultCurrencyListPresenter(view: view, router: self)
        view.presenter = presenter
        
        navigationController.pushViewController(view, animated: true)
    }
    
    func moveToDetailsScreen(for id: String) {
        let detailsController = DefaultCurrencyDetailsView(currencyId: id)
        navigationController.pushViewController(detailsController, animated: true)
    }
}
