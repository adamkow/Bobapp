import UIKit

class ProductListCell: UICollectionViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    
    static let cellIdentifier = String(describing: ProductListCell.self)
    static let cellNib = UINib(nibName: String(describing: ProductListCell.self), bundle: Bundle.main)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // Set data from label
    func updateProductCell(product: ProductList) {
        self.lblProductName.text = product.productName
    }

}
