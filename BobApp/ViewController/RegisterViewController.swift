import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var txtFirstName: CustomTextFiled!
    @IBOutlet weak var txtLastName: CustomTextFiled!
    @IBOutlet weak var txtEmail: CustomTextFiled!
    @IBOutlet weak var txtPassword: CustomTextFiled!
    @IBOutlet weak var txtConfirmPassword: CustomTextFiled!
        
        // Instance Variable to navigate this view controller

    class func instance() -> RegisterViewController {
        let st = UIStoryboard.init(name: "Authentication", bundle: Bundle.main)
        let vc = st.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
        return vc!
    }
    // ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
        // navigate dashboard view controller with register user in firebase

    @IBAction func btnTappedRegister(_ sender: UIButton) {
        if validate {
            self.createUser(email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "") { _ in
                let vc = AppTabViewController.instance()
                SceneDelegate.shared?.window?.rootViewController = vc
            }
        }
    }
    
    @IBAction func btnTappedCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension RegisterViewController {
    func setUI() {
        self.btnRegister.layer.cornerRadius = 20
        self.btnCancel.layer.cornerRadius = 20
        self.btnCancel.borderColor = UIColor.init(named: "#8f1e20")
        self.btnCancel.borderWidth = 1
    }
        /* check validation for textfiled was empty, email is valid or not*/

    var validate: Bool{
        if self.txtFirstName.text == "" {
            self.presentAlert(withTitle: "Message", message: "Please enter firstname!")
            return false
        } else if self.txtLastName.text == "" {
            self.presentAlert(withTitle: "Message", message: "Please enter lastname!")
            return false
        } else if self.txtEmail.text == "" {
            self.presentAlert(withTitle: "Message", message: "Please enter email!")
            return false
        } else if !(self.txtEmail.text!.isValidEmail()) {
            self.presentAlert(withTitle: "Message", message: "Please enter valid email!")
            return false
        } else if self.txtPassword.text == "" {
            self.presentAlert(withTitle: "Message", message: "Please enter password!")
            return false
        } else if self.txtConfirmPassword.text == "" {
            self.presentAlert(withTitle: "Message", message: "Please enter cofirm password!")
            return false
        } else if self.txtPassword.text != self.txtConfirmPassword.text {
            self.presentAlert(withTitle: "Message", message: "Password and Confirm Password are not same!")
            return false
        }
        return true
    }
}
extension RegisterViewController {
        /*  This method used to login specifc user
     - email - this parameter get email value
     - password - this parameter get password value
     - Utility : show progress and still watting to get respose.
                 showProgressHud / hideProgressHud
     - JSON : This was convert response in JSON format
     */
   
    func createUser(email: String, password: String, _ callback: ((Error?) -> ())? = nil){
        Utility.showProgressHUD()
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let e = error{
                Utility.hideProgressHUD()
                callback?(e)
                return
            }
            if Auth.auth().currentUser != nil {
                Utility.hideProgressHUD()
                let user = Auth.auth().currentUser
                if let user = user {
                    let itemReviewRef = Database.database().reference().child("Users").child(user.uid).child("info")
                    var values = ["userId": user.uid, "firstName": self.txtFirstName.text ?? "", "lastName": self.txtLastName.text ?? "", "email": self.txtEmail.text ?? ""]
                    itemReviewRef.updateChildValues(values) {(error, reference) in
                        
                        if error != nil {
                            self.presentAlert(withTitle: "Error", message: "There was a problem while trying to create your account. Please try again.")
                         
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
}
