protocol CurrencyListPresenter {
    var currencies: [CurrencyDescriptor] { get }
    func currencyCellDidTapped(id: String)
    func requestCurrencues()
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
        print(#function)
    }
    
    func requestCurrencues() {
        print(#function)
    }
}
