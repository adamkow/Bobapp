import UIKit
import FirebaseDatabase
import SwiftyJSON
import DropDown

class ProductListViewController: UIViewController {

    @IBOutlet weak var productCategoryColl: UICollectionView!
    @IBOutlet weak var productListColl: UICollectionView!
       // Local variable to used for specfic class

    var arrCategoryData: [Category] = []
    var arrFilterCategoryData: [Category] = []
    var arrProductData: [ProductList] = []
    var arrFilterProductData: [ProductList] = []
   
    var categoryRef : DatabaseReference {
        return Database.database().reference().child("Category")
    }
    var productRef : DatabaseReference {
        return Database.database().reference().child("Product")
    }
        // Instance Variable to navigate this view controller

    class func instance() -> ProductListViewController {
        let st = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main)
        let vc = st.instantiateViewController(withIdentifier: "ProductListViewController") as? ProductListViewController
        return vc!
    }
        // ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
        // filter hot product from all items.

    @IBAction func btnTappedHot(_ sender: UIButton) {
        self.arrFilterCategoryData.removeAll()
        self.arrFilterCategoryData = self.arrCategoryData.filter({$0.productType == "Hot"})
        self.arrFilterCategoryData.forEach({$0.isSelected = false})
        self.arrFilterCategoryData.first?.isSelected = true
        self.productCategoryColl.reloadData()
        
        let catgoryObj = self.arrFilterCategoryData.filter({$0.isSelected == true})
        self.arrFilterProductData.removeAll()
        self.arrFilterProductData = self.arrProductData.filter({$0.categoryId == catgoryObj.first?.categoryId})
        self.productListColl.reloadData()
    }
        // filter cold product from all items.

    @IBAction func btnTappedCold(_ sender: UIButton) {
        self.arrFilterCategoryData.removeAll()
        self.arrFilterCategoryData = self.arrCategoryData.filter({$0.productType == "Cold"})
        self.arrFilterCategoryData.forEach({$0.isSelected = false})
        self.arrFilterCategoryData.first?.isSelected = true
        self.productCategoryColl.reloadData()
        
        let catgoryObj = self.arrFilterCategoryData.filter({$0.isSelected == true})
        self.arrFilterProductData.removeAll()
        self.arrFilterProductData = self.arrProductData.filter({$0.categoryId == catgoryObj.first?.categoryId})
        self.productListColl.reloadData()
    }
}
    /* call different firebase method, register collection view, hide/show login button. */

extension ProductListViewController {
    func setUI() {
        self.collectionSetup()
        self.getCategoryListFromFirebase()
        self.getProductListFromFirebase()
    }
        /* Register collection view */

    func collectionSetup() {
        self.productCategoryColl.register(ProductCategoryCell.cellNib, forCellWithReuseIdentifier: ProductCategoryCell.cellIdentifier)
        self.productCategoryColl.delegate = self
        self.productCategoryColl.dataSource = self
        self.productCategoryColl.reloadData()
        
        self.productListColl.register(ProductListCell.cellNib, forCellWithReuseIdentifier: ProductListCell.cellIdentifier)
        self.productListColl.delegate = self
        self.productListColl.dataSource = self
        self.productListColl.reloadData()
    }
}
extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productCategoryColl {
            return self.arrFilterCategoryData.count
        } else {
            return self.arrFilterProductData.count
        }
    }
        /* collection view to display data and manage difference operation.*/

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == productCategoryColl {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCategoryCell.cellIdentifier, for: indexPath) as? ProductCategoryCell else { return UICollectionViewCell() }
            cell.updateCellData(data: self.arrFilterCategoryData[indexPath.row], isSelected: self.arrFilterCategoryData[indexPath.row].isSelected)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.cellIdentifier, for: indexPath) as? ProductListCell else { return UICollectionViewCell() }
            cell.updateProductCell(product: self.arrFilterProductData[indexPath.row])
            return cell
        }
    }
            // return height and width for a specfic cell

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCategoryColl {
            return CGSize(width: 100.0, height: 40.0)
        } else {
            return CGSize(width: (UIScreen.main.bounds.width - 20) / 2, height: 195)
        }
    }
    // select specfic indexpath.

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productCategoryColl {
           // self.arrFilterCategoryData.removeAll()
            self.arrFilterCategoryData.forEach({$0.isSelected = false})
            self.arrFilterCategoryData[indexPath.row].isSelected = true
            self.productCategoryColl.reloadData()
            
            let catgoryObj = self.arrFilterCategoryData.filter({$0.isSelected == true})
            self.arrFilterProductData.removeAll()
            self.arrFilterProductData = self.arrProductData.filter({$0.categoryId == catgoryObj.first?.categoryId})
            self.productListColl.reloadData()
            
        } else {
            let vc = ProductDetailViewController.instance()
            vc.categoryId = self.arrFilterProductData[indexPath.row].categoryId
            vc.productDetail = self.arrFilterProductData[indexPath.row]
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

    /* This method to get data in Category List from firebase and store array
     */
extension ProductListViewController {
    func getCategoryListFromFirebase() {
        Utility.showProgressHUD()
        categoryRef.observe(.value, with: { snapshot in
            Utility.hideProgressHUD()
            if !snapshot.exists() { return }
            print(JSON(snapshot.value))
            let categoryArrData = JSON(snapshot.value).arrayValue
           // let categoryArr = data.arrayValue
            self.arrCategoryData.removeAll()
            for categoryData in categoryArrData {
                self.arrCategoryData.append(Category(fromJson: categoryData))
            }
            if self.arrCategoryData.count > 0 {
                self.arrCategoryData.first?.isSelected = true
            }
            self.arrFilterCategoryData = self.arrCategoryData
            self.productCategoryColl.reloadData()
        })
    }

        /* This method to get data in Product List from firebase and store array

     */
    
     func getProductListFromFirebase() {
         Utility.showProgressHUD()
         productRef.observe(.value, with: { snapshot in
             Utility.hideProgressHUD()
            if !snapshot.exists() { return }
            print(JSON(snapshot.value))
            let productArrData = JSON(snapshot.value).arrayValue
            self.arrProductData.removeAll()
            for productData in productArrData {
                self.arrProductData.append(ProductList(fromJson: productData))
            }
             
             let categoryId = self.arrCategoryData.first?.categoryId
             self.arrFilterProductData.removeAll()
             self.arrFilterProductData =  self.arrProductData.filter({$0.categoryId == categoryId})
             self.productListColl.reloadData()
        })
    }
}
