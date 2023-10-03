import UIKit
import DropDown
import SwiftyJSON
import FirebaseDatabase
import FirebaseAuth

class ProductDetailViewController: UIViewController {

    // @IBOutlet weak var txtSelectSize: CustomTextFiled!
    // @IBOutlet weak var sizeDropDownAnchorView :UIView!
    @IBOutlet weak var txtSelectMilkType: CustomTextFiled!
    @IBOutlet weak var milkTypeDropDownAnchorView :UIView!
    @IBOutlet weak var txtSelectSugar: CustomTextFiled!
    @IBOutlet weak var sugarTypeDropDownAnchorView :UIView!
   // @IBOutlet weak var txtSelectTopping: CustomTextFiled!
   // @IBOutlet weak var toppingDropDownAnchorView :UIView!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
   // @IBOutlet weak var btnSelectSize: UIButton!
    @IBOutlet weak var btnSelectMilkType: UIButton!
    @IBOutlet weak var btnSelectSugar: UIButton!
    // @IBOutlet weak var btnSelectTopping: UIButton!
    @IBOutlet weak var stackMilkType: UIStackView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var toppingCollectionView: AutoSizeCollectionView!
    
    // var sizeDropDown = DropDown()
    var milkTypeDropDown = DropDown()
    var sugarTypeDropDown = DropDown()
   // var toppingDropDown = DropDown()
    
    var sizeRef : DatabaseReference {
        return Database.database().reference().child("Size")
    }
    var milkRef : DatabaseReference {
        return Database.database().reference().child("Milk")
    }
    var sugarRef : DatabaseReference {
        return Database.database().reference().child("Sugar")
    }
    
    var toppingsRef : DatabaseReference {
        return Database.database().reference().child("Toppings")
    }
    
    var arrSizeList: [SizeClass] = []
    var arrMilkType: [String] = []
    var arrSugarType: [SugarTypeClass] = []
    var arrToppingType: [String] = []
    var categoryId: Int = 0
    var qty = 1
    var productDetail: ProductList?
    var selectedSizeItem = 0
    var selectedIndexPath = [IndexPath]()
    var selectedSizeName = ""
    
    class func instance() -> ProductDetailViewController {
        let st = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main)
        let vc = st.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
        return vc!
    }
        // ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @IBAction func btnTappedSelectSize(_ sender: UIButton) {
       // _ = sizeDropDown.show()
    }

    // drop down for milk type.
    
    @IBAction func btnTappedSelectMilkType(_ sender: UIButton) {
        _ = milkTypeDropDown.show()
    }
    // drop down for sugar type.
    @IBAction func btnTappedSelectSugar(_ sender: UIButton) {
        _ = sugarTypeDropDown.show()
    }
    
    @IBAction func btnTappedSelectTopping(_ sender: UIButton) {
       // _ = toppingDropDown.show()
    }
   // Product add to cart
    @IBAction func btnTappedAddToCart(_ sender: UIButton) {
        self.addProductToCart({_ in
            self.tabBarController?.selectedIndex = 1
            self.navigationController?.popViewController(animated: true)
        })
       
    }
    // Product Qty plus
    @IBAction func btnTappedPlus(_ sender: UIButton) {
        if qty >= 1 {
            qty += 1
            self.lblQty.text = "\(qty)"
        }
    }
    // Product Qty minus
    @IBAction func btnTappedMinues(_ sender: UIButton) {
        if qty != 1 {
            qty -= 1
            self.lblQty.text = "\(qty)"
        }
    }
}
extension ProductDetailViewController {
        /* firebase method and dropdown register*/

    func setUI() {
        self.lblProductName.text = productDetail?.productName ?? ""
        self.setupDropDown()
        self.getSizeListFromFirebase()
        self.getMilkListFromFirebase()
        self.getSugarListFromFirebase()
        self.getToppingListFromFirebase()
    }
        /* Register drop down*/

    private func setupDropDown() {
        
        /* sizeDropDown.anchorView = self.sizeDropDownAnchorView
         sizeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
         self.txtSelectSize.text = item
         //  self.selectStateId = arrStateList[index].stateId ?? ""
         }
         // sizeDropDown.textFont = UIFont.init(name: UIFont.Roboto.Regular.name, size: 16)!
         // sizeDropDown.textColor = UIColor.init(hex: "#0E0D12")
         sizeDropDown.backgroundColor = UIColor.white
         // sizeDropDown.selectionBackgroundColor = UIColor.init(hex: "#F2F2F2")
         sizeDropDown.direction = .bottom
         sizeDropDown.cellHeight = 44
         self.sizeDropDownAnchorView.layoutIfNeeded()
         sizeDropDown.width = self.sizeDropDownAnchorView.bounds.width */
        
        milkTypeDropDown.anchorView = self.milkTypeDropDownAnchorView
        milkTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtSelectMilkType.text = item
            //  self.selectStateId = arrStateList[index].stateId ?? ""
        }
        // sizeDropDown.textFont = UIFont.init(name: UIFont.Roboto.Regular.name, size: 16)!
        // sizeDropDown.textColor = UIColor.init(hex: "#0E0D12")
        milkTypeDropDown.backgroundColor = UIColor.white
        // sizeDropDown.selectionBackgroundColor = UIColor.init(hex: "#F2F2F2")
        milkTypeDropDown.direction = .bottom
        milkTypeDropDown.cellHeight = 44
        self.milkTypeDropDownAnchorView.layoutIfNeeded()
        milkTypeDropDown.width = self.milkTypeDropDownAnchorView.bounds.width
        
        
        sugarTypeDropDown.anchorView = self.sugarTypeDropDownAnchorView
        sugarTypeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtSelectSugar.text = item
            //  self.selectStateId = arrStateList[index].stateId ?? ""
        }
        // sizeDropDown.textFont = UIFont.init(name: UIFont.Roboto.Regular.name, size: 16)!
        // sizeDropDown.textColor = UIColor.init(hex: "#0E0D12")
        sugarTypeDropDown.backgroundColor = UIColor.white
        // sizeDropDown.selectionBackgroundColor = UIColor.init(hex: "#F2F2F2")
        sugarTypeDropDown.direction = .bottom
        sugarTypeDropDown.cellHeight = 44
        self.sugarTypeDropDownAnchorView.layoutIfNeeded()
        sugarTypeDropDown.width = self.sugarTypeDropDownAnchorView.bounds.width
        
        
        /* toppingDropDown.anchorView = self.toppingDropDownAnchorView
         toppingDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
         self.txtSelectTopping.text = item
         //  self.selectStateId = arrStateList[index].stateId ?? ""
         }
         // sizeDropDown.textFont = UIFont.init(name: UIFont.Roboto.Regular.name, size: 16)!
         // sizeDropDown.textColor = UIColor.init(hex: "#0E0D12")
         toppingDropDown.backgroundColor = UIColor.white
         // sizeDropDown.selectionBackgroundColor = UIColor.init(hex: "#F2F2F2")
         toppingDropDown.direction = .bottom
         toppingDropDown.cellHeight = 44
         self.toppingDropDownAnchorView.layoutIfNeeded()
         toppingDropDown.width = self.toppingDropDownAnchorView.bounds.width */
        
        self.setupCollection()
    }

        /* Register collection view */

    
    func setupCollection() {
        self.sizeCollectionView.register(SizeItemCell.cellNib, forCellWithReuseIdentifier: SizeItemCell.cellIdentifier)
        self.sizeCollectionView.delegate = self
        self.sizeCollectionView.dataSource = self
        self.sizeCollectionView.reloadData()
        
        self.toppingCollectionView.register(ToppingItemCell.cellNib, forCellWithReuseIdentifier: ToppingItemCell.cellIdentifier)
        self.toppingCollectionView.delegate = self
        self.toppingCollectionView.dataSource = self
        self.toppingCollectionView.allowsMultipleSelection = true
        self.toppingCollectionView.reloadData()
    }
}

  /* for coolection view to display data and manage difference operation.*/
    
    // return number of section
extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // return number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sizeCollectionView {
            return arrSizeList.count
        } else {
            return arrToppingType.count
        }
    }
    // display collection cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sizeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizeItemCell.cellIdentifier, for: indexPath) as? SizeItemCell else { return UICollectionViewCell() }
            cell.sizeName = self.arrSizeList[indexPath.row].sizeName ?? ""
            if indexPath.row == selectedSizeItem {
                self.selectedSizeName = self.arrSizeList[indexPath.row].sizeName ?? ""
                cell.backView.layer.borderColor = UIColor.black.cgColor
                cell.backView.layer.borderWidth = 1
            } else {
                cell.backView.layer.borderColor = UIColor.clear.cgColor
                cell.backView.layer.borderWidth = 0
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToppingItemCell.cellIdentifier, for: indexPath) as? ToppingItemCell else { return UICollectionViewCell() }
            cell.toppingName = self.arrToppingType[indexPath.row]
            return cell
        }
        
    }
        // return height and width for a specfic cell

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.sizeCollectionView {
            return CGSize.init(width: 100.0, height: 115.0)
        } else {
            let width = (collectionView.bounds.size.width / 2) - 10
            return CGSize(width: width, height: 115.0)
        }
    }
        // select specfic indexpath.

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.sizeCollectionView {
            self.selectedSizeItem = indexPath.row
            self.sizeCollectionView.reloadData()
        } else {
            self.selectedIndexPath.append(indexPath)
        }
    }
        // deselect specfic indexpath.

    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == toppingCollectionView {
            if let selectedItems = collectionView.indexPathsForSelectedItems {
                if selectedItems.contains(indexPath) {
                    self.selectedIndexPath = selectedIndexPath.filter({$0 != indexPath })
                    collectionView.deselectItem(at: indexPath, animated: true)
                    return false
                }
            }
            return true
        } else {
            return true
        }
    }
}
extension ProductDetailViewController {

        /* get data in Size List from firebase and store array

     */
    
    func getSizeListFromFirebase() {
       // Utility.showProgressHUD()
        sizeRef.observe(.value, with: { snapshot in
           // Utility.hideProgressHUD()
            if !snapshot.exists() { return }
            print(JSON(snapshot.value))
            let sizeArrData = JSON(snapshot.value).arrayValue
            self.arrSizeList.removeAll()
            for sizeData in sizeArrData {
                self.arrSizeList.append(SizeClass(fromJson: sizeData))
            }
            self.sizeCollectionView.reloadData()
          //  self.txtSelectSize.text = self.arrSizeList.first?.sizeName ?? ""
            // self.sizeDropDown.dataSource = self.arrSizeList.map({$0.sizeName})
            // self.sizeDropDown.reloadAllComponents()
        })
    }
        /* This method to get data in Milk List from firebase and store array
     */
    func getMilkListFromFirebase() {
       // Utility.showProgressHUD()
        milkRef.observe(.value, with: { snapshot in
           // Utility.hideProgressHUD()
            if !snapshot.exists() { return }
            print(JSON(snapshot.value))
            let milkTypeArrData = JSON(snapshot.value).arrayValue
            self.arrMilkType.removeAll()
            var arrMilkType1: [MilkTypeClass] = []
            for milkType in milkTypeArrData {
                arrMilkType1.append(MilkTypeClass(fromJson: milkType))
            }
            let data = arrMilkType1.filter({$0.categoryId == self.categoryId}).first?.milkName.split(separator: ",") ?? []
            self.arrMilkType = data.map({String($0)})
            
            if self.arrMilkType.count > 0 {
                self.btnSelectMilkType.isUserInteractionEnabled = true
                self.stackMilkType.isHidden = false
                self.txtSelectMilkType.text = self.arrMilkType.first
                self.milkTypeDropDown.dataSource = self.arrMilkType.map({$0})
                self.milkTypeDropDown.reloadAllComponents()
            } else {
                self.btnSelectMilkType.isUserInteractionEnabled = false
                self.stackMilkType.isHidden = true
            }
        })
    }
        /* This method to get data in Sugar list from firebase and store array

     */
    func getSugarListFromFirebase() {
       // Utility.showProgressHUD()
        sugarRef.observe(.value, with: { snapshot in
           // Utility.hideProgressHUD()
            if !snapshot.exists() { return }
            print(JSON(snapshot.value))
            let sizeArrData = JSON(snapshot.value).arrayValue
            self.arrSugarType.removeAll()
            for sizeData in sizeArrData {
                self.arrSugarType.append(SugarTypeClass(fromJson: sizeData))
            }
            self.txtSelectSugar.text = self.arrSugarType.first?.sugarType ?? ""
            self.sugarTypeDropDown.dataSource = self.arrSugarType.map({$0.sugarType})
            self.sugarTypeDropDown.reloadAllComponents()
        })
    }

        /* This method to get data in topping from firebase and store array
     */
    
    func getToppingListFromFirebase() {
        toppingsRef.observe(.value, with: { snapshot in
            // Utility.hideProgressHUD()
            if !snapshot.exists() { return }
            print(JSON(snapshot.value))
            let toppingTypeArrData = JSON(snapshot.value).arrayValue
            
            self.arrToppingType.removeAll()
            var arrMilkType1: [ToppingTypeClass] = []
            for milkType in toppingTypeArrData {
                arrMilkType1.append(ToppingTypeClass(fromJson: milkType))
            }
            let data = arrMilkType1.filter({$0.categoryId == self.categoryId}).first?.toppingType.split(separator: ",") ?? []
            self.arrToppingType = data.map({String($0)})
            
            self.toppingCollectionView.reloadData()
           // self.txtSelectTopping.text = self.arrToppingType.first
            // self.toppingDropDown.dataSource = self.arrToppingType.map({$0})
            // self.toppingDropDown.reloadAllComponents()
        })
    }
}
extension ProductDetailViewController {
    func addProductToCart(_ callback: ((Error?) -> ())? = nil) {
        
        let selectedIndex = selectedIndexPath.map({$0.row})
        let selectTopping = selectedIndex.map({ i in
            return self.arrToppingType[i]
        })
        let toppingString = selectTopping.joined(separator: ",")
        Utility.showProgressHUD()
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                let itemReviewRef = Database.database().reference().child("Cart").child(user.uid).childByAutoId()
                var values = [String: Any]()
                if let product = self.productDetail {
                    values = ["userId": user.uid, "SizeType": self.selectedSizeName, "MilkType": self.txtSelectMilkType.text ?? "", "SugarType": self.txtSelectSugar.text ?? "", "Topping": toppingString, "Qty": self.lblQty.text ?? "", "ProductName": product.productName ?? "", "ProductType": product.productType ?? ""]
                } else {
                    values = ["userId": user.uid, "SizeType": self.selectedSizeName, "MilkType": self.txtSelectMilkType.text ?? "", "SugarType": self.txtSelectSugar.text ?? "", "Topping": toppingString, "Qty": self.lblQty.text ?? ""]
                }
                
                itemReviewRef.updateChildValues(values) {(error, reference) in
                    Utility.hideProgressHUD()
                    if error != nil {
                        self.presentAlert(withTitle: "Error", message: "")
                    } else {
                        callback?(nil)
                    }
                }
            }
        } else {
            Utility.hideProgressHUD()
        }
    }
}
