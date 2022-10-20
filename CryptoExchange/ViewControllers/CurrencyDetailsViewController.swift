import UIKit

final class CurrencyDetailsViewController: UIViewController {

    // MARK: ui views
    private let titleLabel = UILabel();
    private let priceLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: permanent data
    private let currencyId: String
    
    var IsRequestInProgress: Bool = false {
        didSet {
            if IsRequestInProgress {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    init(currencyId: String) {
        self.currencyId = currencyId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupAppearence()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //print("request data for: \(currencyId)")
        requestDetails()
    }
    
    private func updateView(model: CurrencyModel?) {
        titleLabel.text = model?.name ?? "Invalid data"
        titleLabel.sizeToFit()
        
        let formattedPrice = model?.priceInUsd != nil ? String(format: "$%.2f", model!.priceInUsd!) : "-"
        priceLabel.text = formattedPrice
    }

    private func requestDetails() {
        IsRequestInProgress = true
        APIManager.shared.getCurrencyDetails(ids: currencyId) { [weak self] error, models in
            self?.IsRequestInProgress = false
            
            // in case of error array will be empty
            self?.updateView(model: models.isEmpty ? nil : models[0])
            
            if let error = error {
                print(error)
            }
        }
    }
}

private extension CurrencyDetailsViewController {

    // MARK: setup layout
    func setupLayout() {
        view.addSubview(priceLabel)
        
        // navigation bar
        navigationItem.titleView = titleLabel
        
        let barButton = UIBarButtonItem(customView: activityIndicator)
        barButton.customView?.sizeToFit()
        navigationItem.setRightBarButton(barButton, animated: false)
            
        // content
        let layoutGuide = view.safeAreaLayoutGuide;
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 12).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 12).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: 12).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
    }

    // MARK: setup appearence
    func setupAppearence() {
        view.backgroundColor = UIColor(named: "viewBackground")
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        titleLabel.textAlignment = .center
        
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        activityIndicator.hidesWhenStopped = true
    }
    
}


