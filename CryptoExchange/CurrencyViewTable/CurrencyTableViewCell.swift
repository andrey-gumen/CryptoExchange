import UIKit

final class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // MARK: setup appearence
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: update data
    
    func updateData(name: String, price: Double) {
        nameLabel.text = name
        
        let formattedPrice = String(format: "$%.2f", price)
        priceLabel.text = formattedPrice
    }
    
}
