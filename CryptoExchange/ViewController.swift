import UIKit

class ViewController: UIViewController {
    
    private var currencies: [CryptoCurrencyModel] = []
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
            print(models)
            self?.currencies = models
            self?.tableView.reloadData()
        }
    }

}


private extension ViewController {
    
    // MARK: setup layout
    func setupLayout() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    // MARK: setup appearence
    func setupAppearence() {
        tableView.backgroundColor = .darkGray
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
        
        guard let data = currencies[safe: indexPath.row] else {
            cell.updateData(
                name: "Invalid data",
                price: nil
            )
            return cell
        }
        
        cell.updateData(
            name: data.name,
            price: data.priceInUsd
        )
        return cell
    }
    
}

// MAEK: array sugar

extension Collection {
    
  subscript(safe index: Index) -> Iterator.Element? {
    guard indices.contains(index) else { return nil }
    return self[index]
  }
    
}

