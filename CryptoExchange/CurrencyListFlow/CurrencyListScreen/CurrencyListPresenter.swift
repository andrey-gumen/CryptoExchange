protocol CurrencyListPresenter {
    var currencies: [CurrencyDescriptor] { get }
    func currencyCellDidTapped(id: String)
    func requestCurrencies()
}

final class DefaultCurrencyListPresenter: CurrencyListPresenter {
    
    private unowned let view: CurrencyListView
    private let router: CurrencyListRouterInput
    
    var currencies: [CurrencyDescriptor] = []
    
    init(view: CurrencyListView, router: CurrencyListRouterInput) {
        self.view = view
        self.router = router
    }
    
    func currencyCellDidTapped(id: String) {
        router.moveToDetailsScreen(for: id)
    }
    
    func requestCurrencies() {
        view.setActivityIndicator(activated: true)
        
        APIManager.shared.getAssets { [weak self] result in
            self?.view.setActivityIndicator(activated: false)
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let models):
                self?.currencies = models
                self?.view.reloadData()
            }
        }
    }
    
}
