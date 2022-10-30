import UIKit

protocol CurrencyDetailsRouterInput {
    func moveBack()
}

final class CurrencyDetailsRouter {
    
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func moveBack() {
        navigationController.popViewController(animated: true)
    }
    
}
