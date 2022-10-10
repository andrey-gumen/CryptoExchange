import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupAppearence()
        setupBehaviour()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIManager.shared.getAssets { models in
            print(models)
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
        
        tableView.register(CurrencyTableViewCell.nib, forCellReuseIdentifier: CurrencyTableViewCell.cellIdentifier)
    }
    
}

// MARK: implementation UITableViewDelegate / UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

