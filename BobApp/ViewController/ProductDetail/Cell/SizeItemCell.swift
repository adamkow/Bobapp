import UIKit

class SizeItemCell: UICollectionViewCell {

    static let cellIdentifier = String(describing: SizeItemCell.self)
    static let cellNib = UINib(nibName: String(describing: SizeItemCell.self), bundle: Bundle.main)
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var imgSize: UIImageView!
    @IBOutlet weak var lblSize: UILabel!
    
    var sizeName: String? {
        didSet {
            self.lblSize.text = sizeName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
