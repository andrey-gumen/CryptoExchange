import UIKit

final class ViewController: UIViewController {

    private var currencies: [CurrencyDescriptor] = []

    private let tableViewTitleLabel = UILabel()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var IsRequestInProgress: Bool = false {
        didSet {
            if IsRequestInProgress {
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
        setupBehaviour()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationController = navigationController {
            navigationController.isNavigationBarHidden = true
        }
        
        requestAllCurrencies()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationController = navigationController {
            navigationController.isNavigationBarHidden = false
        }
    }

    private func requestAllCurrencies() {
        IsRequestInProgress = true
        APIManager.shared.getAssets { [weak self] error, models in
            self?.IsRequestInProgress = false
            
            // in case of error array will be empty
            self?.currencies = models
            self?.tableView.reloadData()
            
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

private extension ViewController {

    // MARK: setup layout
    func setupLayout() {
        view.addSubview(tableViewTitleLabel)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        let layoutGuide = view.safeAreaLayoutGuide;
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 48).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 48).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -12).isActive = true
        
        tableViewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableViewTitleLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        tableViewTitleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 12).isActive = true
        tableViewTitleLabel.trailingAnchor.constraint(equalTo: activityIndicator.leadingAnchor, constant: -12).isActive = true
        tableViewTitleLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: tableViewTitleLabel.bottomAnchor, constant: 12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
    }

    // MARK: setup appearence
    func setupAppearence() {
        let backgroundScheme = UIColor(named: "viewBackground")
        
        view.backgroundColor = backgroundScheme
        
        tableViewTitleLabel.text = "Exchange Rates"
        tableViewTitleLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        
        tableView.backgroundColor = backgroundScheme
        tableView.rowHeight = 48
        
        activityIndicator.hidesWhenStopped = true
        
//        if let navigationController = navigationController {
//            navigationController.isNavigationBarHidden = true
//        }
    }

    // MARK: setup behaviour
    func setupBehaviour() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(
            CurrencyTableViewCell.nib,
            forCellReuseIdentifier: CurrencyTableViewCell.cellIdentifier
        )
    }
}

// MARK: implementation UITableViewDelegate / UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CurrencyTableViewCell.cellIdentifier,
            for: indexPath
        ) as! CurrencyTableViewCell
        
        let data = currencies[safe: indexPath.row]
        let id = data?.id ?? ""
        let name = data?.name ?? "Invalid data"
        
        cell.updateData(
            name: name,
            price: data?.priceInUsd
        )
        cell.cellDidTappedHandler = {
            //print("tapped: \(name)")
            if let navigationController = self.navigationController {
                let detailsController = CurrencyDetailsViewController(currencyId: id)
                navigationController.pushViewController(detailsController, animated: true)
            }
        }
        
        return cell
    }
}
