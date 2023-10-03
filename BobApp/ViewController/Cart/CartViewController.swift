import UIKit
import FirebaseDatabase
import SwiftyJSON
import FirebaseAuth

class CartViewController: UIViewController {
    // IBOutlet
    @IBOutlet weak var tableView: AutoSizeTblView!
    @IBOutlet weak var placeStackView: UIStackView!
    @IBOutlet weak var placeOrder: UIButton!
    @IBOutlet weak var orderListTableView: AutoSizeTblView!
    // Local variable used for specific class
    var cartRef : DatabaseReference {
        return Database.database().reference().child("Cart")
    }
    var orderRef : DatabaseReference {
        return Database.database().reference().child("Orders")
    }
    var arrCartList: [CartModel] = []
    var arrOrderList: [OrderModel] = []
    // Instance Variable to navigate this view controller
    class func instance() -> CartViewController {
        let st = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main)
        let vc = st.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController
        return vc!
    }
    // ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    // button action to place order in cart
    // Remove order in cart list and order move to order list.
    @IBAction func btnTappedPlaceOrder(_ sender: UIButton) {
        for data in self.arrCartList {
            if Auth.auth().currentUser != nil {
                let user = Auth.auth().currentUser
                if let user = user {
                    let itemReviewRef = Database.database().reference().child("Orders").child(user.uid).childByAutoId()
                    let values = ["userId": user.uid, "SizeType": data.sizeType ?? "", "MilkType": data.milkType ?? "", "SugarType": data.sugarType ?? "", "Topping": data.topping ?? "", "Qty": data.qty ?? "", "ProductName": data.productName ?? "", "OrderStatus":"Preparing"]
                    itemReviewRef.updateChildValues(values) {(error, reference) in
                        Utility.hideProgressHUD()
                        if error != nil {
                            self.presentAlert(withTitle: "Error", message: "")
                        } else {
                            
                        }
                    }
                }
            }
        }
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                self.cartRef.child(user.uid).removeValue { error, _ in
                    if error == nil {
                        self.getCartListFromFirebase()
                    } else {
                        self.presentAlert(withTitle: "Error", message: "")
                    }
                }
            }
        }
    }
}
extension CartViewController {
        /* This method to Register Table View and get data from firebase */
    func setUI() {
        self.placeOrder.layer.cornerRadius = 20
        self.placeOrder.layer.borderColor = UIColor(named: "#8f1e20")?.cgColor
        self.placeOrder.layer.borderWidth = 1
        // tableView
        self.tableView.register(CartListCell.cellNib, forCellReuseIdentifier: CartListCell.cellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        
        self.orderListTableView.register(CustOrderListCell.cellNib, forCellReuseIdentifier: CustOrderListCell.cellIdentifier)
        self.orderListTableView.dataSource = self
        self.orderListTableView.delegate = self
        self.orderListTableView.reloadData()
        
        self.getCartListFromFirebase()
        //
        self.getOrderListFromFirebase()
    }
}
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    /* This all method for table view to display data and manage difference operation.*/
    
    // This method to return number of section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // This method return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return self.arrCartList.count
        } else {
            return self.arrOrderList.count
        }
        
    }
        // This method return table view cell with need to data display

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CartListCell.cellIdentifier) as? CartListCell else {
                return UITableViewCell()
            }
            cell.lblProductName.text = self.arrCartList[indexPath.row].productName
            cell.lblProductSize.text = self.arrCartList[indexPath.row].sizeType
            cell.lblToppingName.text = self.arrCartList[indexPath.row].topping
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustOrderListCell.cellIdentifier) as? CustOrderListCell else {
                return UITableViewCell()
            }
            cell.lblProductName.text = self.arrOrderList[indexPath.row].productName
            cell.lblProductSize.text = self.arrOrderList[indexPath.row].sizeType
            cell.lblToppingName.text = self.arrOrderList[indexPath.row].topping
            
            return cell
        }
    }
        // This Method return a table view cell height

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        // This method for a swipe to delete for a selected row.

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == self.tableView {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
                self.deleteData(at: indexPath)
            }
           // let editAction = UIContextualAction(style: .normal, title: "Edit") {  (contextualAction, view, boolValue) in
           //     self.editData(at: indexPath)
           // }
           // editAction.backgroundColor = .purple
            deleteAction.backgroundColor = .red
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
            return swipeActions
        } else {
            return nil
        }
    }
        // This method give a access for a edit a specifc row

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        /* This method delete data from cart
     - Cart firebase node remove data specfic item id
     - Array Cart list to get specifc unique id.
     */
    
    func deleteData(at indexPath: IndexPath) {
        // print(indexPath.row)
        let cartItemId = self.arrCartList[indexPath.row].uid ?? ""
        let user = Auth.auth().currentUser
        if let user = user {
            let uesrRef = Database.database().reference().child("Cart").child(user.uid).child(cartItemId).removeValue { error, _ in
                if error == nil {
                    self.getCartListFromFirebase()
                }
            }
        }
    }
    
    func editData(at indexPath: IndexPath) {
        print(indexPath.row)
    }
}
extension CartViewController {

      /* This method to get data in cart data from firebase and store array
     */
    
    func getCartListFromFirebase() {
        Utility.showProgressHUD()
        let user = Auth.auth().currentUser
        if let user = user {
            cartRef.child(user.uid).observe(.value, with: { snapshot in
                Utility.hideProgressHUD()
                if !snapshot.exists() { return }
                print(JSON(snapshot.value))
                guard let userDictionary = snapshot.value as? [String: Any] else { return }
                self.arrCartList.removeAll()
                for (key, value) in userDictionary {
                    guard let dic = value as? [String: Any] else {
                         continue
                    }
                    print(dic)
                    let cartModel = CartModel(uid: key, fromDictionary: dic)
                    self.arrCartList.append(cartModel)
                    self.tableView.reloadData()
                    if self.arrCartList.count > 0 {
                        self.placeStackView.isHidden = false
                    } else {
                        self.placeStackView.isHidden = true
                    }
                }
            })
        } else {
            Utility.hideProgressHUD()
        }
    }
        /* This method to get data in order data from firebase and store array
     */
    
    func getOrderListFromFirebase() {
        Utility.showProgressHUD()
        let user = Auth.auth().currentUser
        if let user = user {
            orderRef.child(user.uid).observe(.value, with: { snapshot in
                Utility.hideProgressHUD()
                if !snapshot.exists() { return }
                print(JSON(snapshot.value))
                guard let userDictionary = snapshot.value as? [String: Any] else { return }
                self.arrOrderList.removeAll()
                for (key, value) in userDictionary {
                    guard let dic = value as? [String: Any] else {
                         continue
                    }
                    print(dic)
                    let cartModel = OrderModel(uid: key, fromDictionary: dic)
                    self.arrOrderList.append(cartModel)
                    self.orderListTableView.reloadData()
//                    if self.arrOrderList.count > 0 {
//                        self.placeStackView.isHidden = false
//                    } else {
//                        self.placeStackView.isHidden = true
//                    }
                }
            })
        } else {
            Utility.hideProgressHUD()
        }
    }
}
