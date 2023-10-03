import UIKit

class AppTabViewController: UITabBarController {

    class func instance() -> AppTabViewController {
        let st = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main)
        let vc = st.instantiateViewController(withIdentifier: "AppTabViewController") as? AppTabViewController
        return vc!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
