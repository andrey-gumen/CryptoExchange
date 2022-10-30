import UIKit

protocol CurrencyDetailsView: AnyObject {
    func setActivityIndicator(activated: Bool)
    func updateView()
}

final class CurrencyDetailsViewController: UIViewController {

    // MARK: ui views
    private let titleLabel = UILabel();
    private let iconImage = UIImageView()
    private let typeLabel = UILabel()
    private let priceLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: permanent data
    private let currencyId: String
    
    private var isRequestInProgress: Bool = false {
        didSet {
            if isRequestInProgress {
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

        sendGroupRequests()
    }
    
    func updateView(model: CurrencyModel?, icon: UIImage?) {
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

private extension CurrencyDetailsViewController {
    
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
    
    // MARK: reqeasts
    
    func sendGroupRequests() {
        isRequestInProgress = true
        
        var tmpModel: CurrencyModel?
        var tmpImage: UIImage?
        
        let group = DispatchGroup()
        group.enter()
        requestDetails(id: currencyId) { model in
            tmpModel = model
            group.leave()
        }
        
        group.enter()
        requestIcon(id: currencyId) { image in
            group.leave()
            tmpImage = image
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.updateView(model: tmpModel, icon: tmpImage)
            self.isRequestInProgress = false
        }
    }
      
    func requestDetails(id: String, completion: @escaping (CurrencyModel?) -> ()) {
        APIManager.shared.getCurrencyDetails(ids: id) { result in
            var model: CurrencyModel? = nil
            switch result {
            case .success(let models):
                model = models[0]
            case .failure(let error):
                print(error)
            }
            
            completion(model)
        }
    }
    
    func requestIcon(id: String, completion: @escaping (UIImage?) -> ()) {
        APIManager.shared.getCurrencyIcon { result in
            let group = DispatchGroup()
            var image: UIImage? = nil
            
            switch result {
            case .success(let icons):
                if let icon = icons.first(where: {$0.id == id}) {
                    group.enter()
                    APIManager.shared.downloadImage(url: icon.iconUrl) { result in
                        switch result {
                        case .success(let downloadedImage):
                            image = downloadedImage
                        case .failure(let error):
                            print(error)
                        }
                        
                        group.leave()
                    }
                }
            case .failure(let error):
                print(error)
            }
            
            group.notify(queue: DispatchQueue.global()) {
                completion(image)
            }
        }
    }
}


