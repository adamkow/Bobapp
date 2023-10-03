import Foundation
import UIKit

class CustomTextFiled: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override init(frame: CGRect) {
        // Override frame 
        super.init(frame: frame)
        self.commonSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }

    func commonSetup() {
       
        self.borderWidth = 1.0
        self.cornerRadius = 5.0
        self.borderStyle = .none
        self.autocorrectionType = .no
    }
}
