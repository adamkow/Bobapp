import Foundation
import UIKit

// var appDelegate = UIApplication.shared.delegate as! AppDelegate

public var backView = UIView()

func rotateAnimation(imageView:UIImageView,duration: CFTimeInterval = 2.0) {
    let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
    rotateAnimation.fromValue = 0.0
    rotateAnimation.toValue = CGFloat(.pi * 2.0)
    rotateAnimation.duration = duration
    rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
    imageView.layer.add(rotateAnimation, forKey: nil)
}

class Utility: NSObject {
    
    class func showProgressHUD() {
        for subUIView in backView.subviews as! [UIImageView] {
            subUIView.removeFromSuperview()
        }
        self.hideProgressHUD()
        backView.frame =  CGRect(x: 0, y: 0, width:  SceneDelegate.shared!.window!.frame.size.width, height: SceneDelegate.shared!.window!.frame.size.height)
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.30)
        let imgViewRing = UIImageView(image: UIImage(named: "Loading"))
        imgViewRing.setImageTintColor(color: UIColor.black)
        imgViewRing.removeFromSuperview()
        imgViewRing.contentMode = .scaleAspectFit
        imgViewRing.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        // imgViewRing.frame = CGRect(x: 0, y: 0, width: backView.frame.size.width/6.0, height: backView.frame.size.width/6.0)
        imgViewRing.center = CGPoint(x: backView.frame.size.width/2.0, y: backView.frame.size.height/2.0)
        rotateAnimation(imageView: imgViewRing)
        backView.addSubview(imgViewRing)
        SceneDelegate.shared?.window?.addSubview(backView)
        // actualView.view.addSubview(backView)
    }
    
    class func hideProgressHUD() {
        backView.removeFromSuperview()
        SceneDelegate.shared?.window?.setNeedsLayout()
    }
}


class AutoSizeCollectionView: UICollectionView {
    
    @IBOutlet weak var conHeight: NSLayoutConstraint!
    
    var minHeight: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    func removeObs() {
        removeObserver(self, forKeyPath: "contentSize")
    }
    deinit {
        print("")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let obj = object as? UICollectionView {
                conHeight?.constant = obj.contentSize.height
                if let minheightt = minHeight {
                    conHeight?.constant = max(minheightt, obj.contentSize.height)
                    conHeight?.constant = max(minheightt, obj.contentSize.height)
                }
            }
        }
    }
}


class AutoSizeTblView: UITableView{
    @IBOutlet var conTblHeight: NSLayoutConstraint!
    var minHeight: CGFloat!
    var maxHeight: CGFloat!
    override func awakeFromNib() {
        super.awakeFromNib()
        addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"{
            if let obj = object as? UITableView{
                conTblHeight?.constant = obj.contentSize.height
                if let minheightt = minHeight{
                    conTblHeight?.constant = max(minheightt, obj.contentSize.height)
                    conTblHeight?.constant = max(minheightt, obj.contentSize.height)
                }
                if let maxheightt = maxHeight{
                    conTblHeight?.constant = min(maxheightt, obj.contentSize.height)
                }
            }
        }
    }
}
