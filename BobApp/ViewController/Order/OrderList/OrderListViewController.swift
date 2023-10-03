import UIKit

class OrderListViewController: UIViewController {

    class func instance() -> OrderListViewController {
        let st = UIStoryboard.init(name: "Order", bundle: Bundle.main)
        let vc = st.instantiateViewController(withIdentifier: "OrderListViewController") as? OrderListViewController
        return vc!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
