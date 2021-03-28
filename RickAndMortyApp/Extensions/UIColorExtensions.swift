import UIKit

extension UIColor {

    static var titleColor: UIColor {
        get {
            if #available(iOS 13.0, *) {
                return UIColor.label
            } else {
                return UIColor.black
            }
        }
    }

    static var subtitleColor: UIColor {
        get {
            if #available(iOS 13.0, *) {
                return UIColor.systemGray
            } else {
                return UIColor.lightGray
            }
        }
    }

    static var backgroundColor: UIColor {
        get {
            if #available(iOS 13.0, *) {
                return UIColor.systemBackground
            } else {
                return UIColor.white
            }
        }
    }

    static var borderColor: UIColor {
        get {
            if #available(iOS 13.0, *) {
                return UIColor.systemGray2
            } else {
                return UIColor.gray
            }
        }
    }
}
