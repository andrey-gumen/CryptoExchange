import UIKit

protocol CurrencyListRouterInput {
    func moveToDetailsScreen()
}

final class CurrencyListRouter: CurrencyListRouterInput {
    
    let navigationController: UINavigationController?
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let view = DefaultCurrencyListView()
        let presenter = DefaultCurrencyListPresenter(view: view, router: self)
        view.presenter = presenter
        
        navigationController.pushViewController(view, animated: true)
    }
    
    func moveToDetailsScreen() {
        print(#function)
    }
}
