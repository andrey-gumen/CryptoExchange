import UIKit

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
        let layoutGuide = view.safeAreaLayoutGuide;
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 12).isActive = true
        iconImage.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 12).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 12).isActive = true
        typeLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 12).isActive = true
        typeLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: 12).isActive = true
        typeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 12).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 12).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: 12).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
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


