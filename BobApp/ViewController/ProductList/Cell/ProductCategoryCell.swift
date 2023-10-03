import UIKit

class ProductCategoryCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
        // Register for CollectionViewCell

    static let cellIdentifier = String(describing: ProductCategoryCell.self)
    static let cellNib = UINib(nibName: String(describing: ProductCategoryCell.self), bundle: Bundle.main)
        // background view border color, width and cornor radius

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backView.borderWidth = 1
        self.backView.borderColor = UIColor.black
        self.backView.cornerRadius = self.backView.bounds.height / 2
    }
        // Set data from lable and border color

    func updateCellData(data: Category, isSelected: Bool = false) {
        if isSelected {
            self.lblTitle.text = data.categoryName
            self.backView.borderColor = UIColor.init(named: "#8f1e20")
        } else {
            self.lblTitle.text = data.categoryName
            self.backView.borderColor = UIColor.black
        }
    }
}
