import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
        
        // Instance Variable to navigate this view controller

    class func instance() -> SettingViewController {
        let st = UIStoryboard.init(name: "Dashboard", bundle: Bundle.main)
        let vc = st.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController
        return vc!
    }
    // ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
        // logout for specfic user login.

    @IBAction func btnTappedLogout(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            AppGlobalConfig.shared.setLoginScreen()
        } catch {
            
        }
    }
        // remove user account in database

    @IBAction func btnTappedDelete(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            if let user = user {
                let uesrRef = Database.database().reference().child("Users").child(user.uid).removeValue { error, _ in
                    if error == nil {
                        let user = Auth.auth().currentUser
                        user?.delete { error in
                          if let _ = error {
                              self.presentAlert(withTitle: "Success", message: "Your account was not deleted!")
                          } else {
                              AppGlobalConfig.shared.setLoginScreen()
                          }
                        }
                    } else {
                        
                    }
                }
            }
        }
    }
}
extension SettingViewController {
    func setUI() {
        // Delete Button
        self.btnDelete.layer.cornerRadius = 20
        self.btnDelete.layer.borderColor = UIColor(named: "#8f1e20")?.cgColor
        self.btnDelete.layer.borderWidth = 1
        
        self.btnLogout.layer.cornerRadius = 30
        if let auth = Auth.auth().currentUser {
            self.backView.isHidden = true
            self.btnLogout.isHidden = false
            self.getUserDetail(userId: auth.uid)
        } else {
            self.btnLogout.isHidden = true
            self.backView.isHidden = true
        }
    }
        /* This method to get user detail
     - userId - this parameter for specfic user unique id
     - function get firstname, lastname and email
     */
    func getUserDetail(userId: String) {
        let userRef = Database.database().reference().child("Users").child(userId).child("info")
        userRef.observe(.value, with: {(snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                // print(dict)
                self.backView.isHidden = false
                var fName = ""
                if let firstName = dict["firstName"] as? String {
                    fName = firstName
                }
                var lName = ""
                if let lastName = dict["lastName"] as? String {
                    lName = lastName
                }
                self.lblName.text = fName+" "+lName
                
                if let email = dict["email"] as? String {
                    self.lblEmail.text = email
                }
            }
        })
    }
}
