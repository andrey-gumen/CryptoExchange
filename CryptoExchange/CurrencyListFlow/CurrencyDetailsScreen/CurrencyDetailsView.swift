import UIKit
import EasyAutolayout

protocol CurrencyDetailsView: AnyObject {
    func setActivityIndicator(activated: Bool)
    func updateView()
}

final class DefaultCurrencyDetailsView: UIViewController {
    
    var presenter: CurrencyDetailsPresenter?

    // MARK: ui views
    private let titleLabel = UILabel();
    private let iconImage = UIImageView()
    private let typeLabel = UILabel()
    private let priceLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private var isRequestInProgress: Bool = false {
        didSet {
            if isRequestInProgress {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupAppearence()
        
        assert(presenter != nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.requestCurrencyDetails()
    }
    
    private func updateView(model: CurrencyModel?, icon: UIImage?) {
        titleLabel.text = model?.name ?? "Invalid data"
        titleLabel.sizeToFit()
        
        iconImage.image = icon
        
        let currencyTypeInfo = model?.isCryptoCurrency == nil
            ? "unknown type"
            : model?.isCryptoCurrency == 1 ? "crypto currency"
            : "fiat currency"
        typeLabel.text = String(format: "This is %@", currencyTypeInfo)
        
        let formattedPrice = model?.priceInUsd != nil ? String(format: "Price: $%.2f", model!.priceInUsd!) : "-"
        priceLabel.text = formattedPrice
    }
    
}

private extension DefaultCurrencyDetailsView {
    
    // MARK: setup layout
    func setupLayout() {
        view.addSubview(iconImage)
        view.addSubview(typeLabel)
        view.addSubview(priceLabel)
        
        // navigation bar
        navigationItem.titleView = titleLabel
        
        let barButton = UIBarButtonItem(customView: activityIndicator)
        barButton.customView?.sizeToFit()
        navigationItem.setRightBarButton(barButton, animated: false)
            
        // content
        iconImage.pin
            .top(to: view.safeAreaLayoutGuide, offset: 12)
            .leading(to: view, offset: 12)
            .size(to: CGSize(width: 48, height: 48))
        
        typeLabel.pin
            .below(of: iconImage, offset: 12)
            .leading(to: view, offset: 12)
            .trailing(to: view, offset: 12)
            .height(to: 24)
        
        priceLabel.pin
            .below(of: typeLabel, offset: 12)
            .leading(to: view, offset: 12)
            .trailing(to: view, offset: 12)
            .height(to: 24)
    }

    // MARK: setup appearence
    func setupAppearence() {
        view.backgroundColor = ColorScheme.viewBackground
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        titleLabel.textAlignment = .center
        
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        activityIndicator.hidesWhenStopped = true
    }

}

// MARK: CurrencyDetailsView implementation

extension DefaultCurrencyDetailsView: CurrencyDetailsView {
    func setActivityIndicator(activated: Bool) {
        isRequestInProgress = activated
    }
    
    func updateView() {
        updateView(
            model: presenter?.currencyModel,
            icon: presenter?.currencyIcon
        )
    }
}


