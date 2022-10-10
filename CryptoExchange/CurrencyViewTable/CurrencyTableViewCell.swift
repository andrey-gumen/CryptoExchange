import UIKit

final class CurrencyTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "CurrencyTableViewCell"
    static let nib = UINib(nibName: "CurrencyTableViewCell", bundle: nil)

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // MARK: setup appearence
        backgroundColor = UIColor(named: "currencyCellBackground")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: update data
    
    func updateData(name: String, price: Double?) {
        nameLabel.text = name
        
        let formattedPrice = price != nil ? String(format: "$%.2f", price!) : "-"
        priceLabel.text = formattedPrice
    }
    
}
