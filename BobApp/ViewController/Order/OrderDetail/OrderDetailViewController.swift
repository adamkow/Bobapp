import UIKit

class OrderDetailViewController: UIViewController {

    class func instance() -> OrderDetailViewController {
        let st = UIStoryboard.init(name: "Order", bundle: Bundle.main)
        let vc = st.instantiateViewController(withIdentifier: "OrderDetailViewController") as? OrderDetailViewController
        return vc!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
