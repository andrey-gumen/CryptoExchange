import UIKit

protocol CurrencyDetailsPresenter {
    var currencyModel: CurrencyModel? { get }
    var currencyIcon: UIImage? { get }
    
    func requestCurrencyDetails()
}
