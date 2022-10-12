import UIKit

final class CurrencyTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "CurrencyTableViewCell"
    static let nib = UINib(nibName: "CurrencyTableViewCell", bundle: nil)

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    var cellDidTappedHandler: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAppearence()
        setupBehaviour()
    }

    // MARK: update data
    
    func updateData(name: String, price: Double?) {
        nameLabel.text = name
        
        let formattedPrice = price != nil ? String(format: "$%.2f", price!) : "-"
        priceLabel.text = formattedPrice
    }
    
    // MARK: setup behaviour
    
    private func setupBehaviour() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        cellDidTappedHandler?()
    }
    
    // MARK: setup appearence
    
    private func setupAppearence() {
        backgroundColor = UIColor(named: "currencyCellBackground")
    }
    
}
