import UIKit

class ToppingItemCell: UICollectionViewCell {

    static let cellIdentifier = String(describing: ToppingItemCell.self)
    static let cellNib = UINib(nibName: String(describing: ToppingItemCell.self), bundle: Bundle.main)
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgSize: UIImageView!
    @IBOutlet weak var lblTopping: UILabel!
    
        // This method to selected or unselected specfic cell

    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.clear.cgColor
        }
    }
    
    var toppingName: String? {
        didSet {
            self.lblTopping.text = toppingName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
