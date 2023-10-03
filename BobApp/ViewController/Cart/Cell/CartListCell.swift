import UIKit

class CartListCell: UITableViewCell {
    // Register TableViewCell
    static let cellIdentifier = String(describing: CartListCell.self)
    static let cellNib = UINib(nibName: String(describing: CartListCell.self), bundle: Bundle.main)
    // Connect IBOutlet
    @IBOutlet weak var imgItemPhoto: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductSize: UILabel!
    @IBOutlet weak var lblToppingName: UILabel!
    // Set Data from lable
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
