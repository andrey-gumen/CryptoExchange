import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupAppearence()
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
    }
    
}

