import UIKit

final class ViewController: UIViewController {

    private var currencies: [CryptoCurrencyModel] = []

    private let tableViewTitleLabel = UILabel()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupAppearence()
        setupBehaviour()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        requestAllCurrencies()
    }

    private func requestAllCurrencies() {
        APIManager.shared.getAssets { [weak self] models in
            // print(models)
            self?.currencies = models
            self?.tableView.reloadData()
        }
    }
}

private extension ViewController {

    // MARK: setup layout
    func setupLayout() {
        view.addSubview(tableViewTitleLabel)
        view.addSubview(tableView)

        tableViewTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableViewTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        tableViewTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
        tableViewTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 12).isActive = true
        tableViewTitleLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: tableViewTitleLabel.bottomAnchor, constant: 12).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    // MARK: setup appearence
    func setupAppearence() {
        tableViewTitleLabel.text = "Exchange Rates"
        tableViewTitleLabel.font = UIFont.boldSystemFont(ofSize: 25.0)

        tableView.backgroundColor = UIColor(named: "currencyTableViewBackgrounds")
        tableView.rowHeight = 48
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
        cell.updateData(
            name: data?.name ?? "Invalid data",
            price: data?.priceInUsd
        )
        return cell
    }
}
