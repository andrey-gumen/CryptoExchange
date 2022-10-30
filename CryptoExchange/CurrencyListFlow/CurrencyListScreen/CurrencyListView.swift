import UIKit

protocol CurrencyListView: AnyObject {
    func setActivityIndicator(activated: Bool)
    func repaintList()
}
final class DefaultCurrencyListView: UIViewController {
    
    // MARK: - Properties
    var presenter: CurrencyListPresenter?
    
    // MARK: Public
    // MARK: Private
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(presenter != nil)
    }
    
    // MARK: - API
    // MARK: - Setups
    // MARK: - Helpers
    
}

// MARK: CurrencyListView implementation

extension DefaultCurrencyListView: CurrencyListView {
    
    func setActivityIndicator(activated: Bool) {
        print(#function)
        }
    
    func repaintList() {
        print(#function)
        }
    }
    
}
