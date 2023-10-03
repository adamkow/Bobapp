import UIKit

class CustOrderListCell: UITableViewCell {
    // Register TableViewCell
    static let cellIdentifier = String(describing: CustOrderListCell.self)
    static let cellNib = UINib(nibName: String(describing: CustOrderListCell.self), bundle: Bundle.main)
    // Connect IBOutlet
    @IBOutlet weak var imgItemPhoto: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductSize: UILabel!
    @IBOutlet weak var lblToppingName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
