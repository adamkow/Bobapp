import Foundation
import UIKit

extension UIImageView {
    
    func setImageTintColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    /* func setImageSd(url: String, placeHolder: String? = nil, isIndicatorShow: Bool = true) {
        
        if let loadUrl = URL.init(string: url) {
            if UIApplication.shared.canOpenURL(loadUrl) {
                if isIndicatorShow {
                    self.sd_imageIndicator = SDWebImageActivityIndicator.gray
                }
                sd_setImage(with: loadUrl, placeholderImage: placeHolder != nil ? UIImage.init(named: placeHolder!) : nil, completed: nil)
            } else {
                self.image = placeHolder != nil ? UIImage.init(named: placeHolder!) : nil
            }
            
        } else {
            self.image = placeHolder != nil ? UIImage.init(named: placeHolder!) : nil
        }
    } */
}
