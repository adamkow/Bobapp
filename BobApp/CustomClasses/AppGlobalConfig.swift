import Foundation
import UIKit
import FirebaseAuth

class AppGlobalConfig {
    
    static var shared = AppGlobalConfig()
    // root view controller
    // user login to navigate dashboard view controller otherwise redirct login view controller
    func setRootViewScreen() {
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                let vc = AppTabViewController.instance()
                SceneDelegate.shared?.window?.rootViewController = vc
            } else {
                let vc = LoginViewController.instance()
                let navigation = UINavigationController.init(rootViewController: vc)
                navigation.isNavigationBarHidden = true
                SceneDelegate.shared?.window?.rootViewController = navigation
            }
        }
    }
    // set root view controller
    // Navigate to login view controller 
    func setLoginScreen() {
        let vc = LoginViewController.instance()
        let navigation = UINavigationController.init(rootViewController: vc)
        navigation.isNavigationBarHidden = true
        SceneDelegate.shared?.window?.rootViewController = navigation
    }
}
