import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUserName: CustomTextFiled!
    @IBOutlet weak var txtPassword: CustomTextFiled!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnSkipLogin: UIButton!

        // Instance Variable to navigate this view controller

    class func instance() -> LoginViewController {
        let st = UIStoryboard.init(name: "Authentication", bundle: Bundle.main)
        let vc = st.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        return vc!
    }
        // ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
        // button action to navigate dashboard view controller verify via email and password.

    @IBAction func btnTappedLogin(_ sender: UIButton) {
        if validate {
            self.loginRequest(userName: self.txtUserName.text ?? "", password: self.txtPassword.text ?? "")
        }
    }
        // button action to navigate register view controller

    @IBAction func btnTappedRegister(_ sender: UIButton) {
        let vc = RegisterViewController.instance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
        // button action to navigate dashboard view controller and skip login process.

    @IBAction func btnTappedSkip(_ sender: UIButton) {
        let vc = AppTabViewController.instance()
        SceneDelegate.shared?.window?.rootViewController = vc
    }
}
extension LoginViewController {
    func setUI() {
        self.btnLogin.layer.cornerRadius = 20
        self.btnRegister.layer.cornerRadius = 20
        self.btnRegister.borderColor = UIColor.init(named: "#8f1e20")
        self.btnRegister.borderWidth = 1
        self.btnSkipLogin.underline()
    }
        /* check validation for textfiled was empty, email is valid or not*/

    var validate: Bool{
        if self.txtUserName.text == "" {
            self.presentAlert(withTitle: "Message", message: "Please enter username!")
            return false
        } else if !(self.txtUserName.text!.isValidEmail()) {
            self.presentAlert(withTitle: "Message", message: "Please enter valid username!")
            return false
        }
        else if self.txtPassword.text == "" {
            self.presentAlert(withTitle: "Message", message: "Please enter password!")
            return false
        }
        return true
    }
}

    /*  This method used to login specifc user
     - userName - this parameter get email value
     - password - this parameter get password value
     - Utility : show progress and still watting to get respose.
                 showProgressHud / hideProgressHud
     - JSON : This was convert response in JSON format
     */
extension LoginViewController {
    func loginRequest(userName: String, password: String) {
        Utility.showProgressHUD()
        Auth.auth().signIn(withEmail: userName, password: password) { (authResult, error) in
            if let authResult = authResult {
                let user = authResult.user
                print("User has Signed In")
                if user.isEmailVerified {
                    print("is Email Verified")
                } else {
                    print("is Email Not Verified")
                }
                Utility.hideProgressHUD()
                let vc = AppTabViewController.instance()
                SceneDelegate.shared?.window?.rootViewController = vc
            } else {
                Utility.hideProgressHUD()
                if let error = error {
                    self.presentAlert(withTitle: "Error", message: "Cant Sign in user")
                }
            }
        }
    }
}


extension UIViewController {
    // show alerts
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
      }
}
