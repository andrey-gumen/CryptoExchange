import UIKit
import EasyAutolayout

protocol CurrencyListView: AnyObject {
    func setActivityIndicator(activated: Bool)
    func reloadData()
}

final class DefaultCurrencyListView: UIViewController {
    
    // MARK: - Properties
    var presenter: CurrencyListPresenter?
    
    // MARK: Public
    // MARK: Private
    private let tableViewTitleLabel = UILabel()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var isRequestInProgress: Bool = false {
        didSet {
            if isRequestInProgress {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupAppearence()
        setupBehaviour()
        
        assert(presenter != nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationController = navigationController {
            navigationController.isNavigationBarHidden = true
        }
        
        presenter?.requestCurrencues()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationController = navigationController {
            navigationController.isNavigationBarHidden = false
        }
    }
    
    // MARK: - API
    // MARK: - Setups
    func setupLayout() {
        view.addSubview(tableViewTitleLabel)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        activityIndicator.pin
            .top(to: view.safeAreaLayoutGuide)
            .trailing(to: view, offset: -12)
            .size(to: CGSize(width: 48, height: 48))
        
        tableViewTitleLabel.pin
            .top(to: view.safeAreaLayoutGuide)
            .height(to: 48)
            .leading(to: view, offset: 12)
            .trailing(to: view, offset: -12)
        
        tableView.pin
            .below(of: tableViewTitleLabel)
            .leading(to: view)
            .trailing(to: view)
            .bottom(to: view)
    }

    func setupAppearence() {
        let backgroundScheme = ColorScheme.currencyTableViewBackground
        
        view.backgroundColor = backgroundScheme
        
        tableViewTitleLabel.text = "Exchange Rates"
        tableViewTitleLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
        
        tableView.backgroundColor = backgroundScheme
        tableView.rowHeight = 48
        
        activityIndicator.hidesWhenStopped = true
    }

    func setupBehaviour() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(
            CurrencyTableViewCell.nib,
            forCellReuseIdentifier: CurrencyTableViewCell.cellIdentifier
        )
    }
    
    // MARK: - Helpers
    
}

// MARK: CurrencyListView implementation

extension DefaultCurrencyListView: CurrencyListView {
    
    func setActivityIndicator(activated: Bool) {
        isRequestInProgress = activated
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
}

// MARK: UITableViewDelegate / UITableViewDataSource implementation

extension DefaultCurrencyListView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.currencies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CurrencyTableViewCell.cellIdentifier,
            for: indexPath
        ) as! CurrencyTableViewCell
        
        let data = presenter?.currencies[safe: indexPath.row]
        let id = data?.id ?? ""
        let name = data?.name ?? "Invalid data"
        
        cell.updateData(
            name: name,
            price: data?.priceInUsd
        )
        cell.cellDidTappedHandler = {
            self.presenter?.currencyCellDidTapped(id: id)
        }
        
        return cell
    }
}

