import UIKit

struct LayoutConstants {

    static var cornerRadius: CGFloat = 8.0

    static var itemsPerRow: CGFloat {
        get {
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                return itemsPerRowIfIpad
            default:
                return itemsPerRowIfIphone
            }
        }
    }

    static private var itemsPerRowIfIpad: CGFloat {
        get {
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown:
                return 4
            default:
                return 5
            }
        }
    }

    static private var itemsPerRowIfIphone: CGFloat = 2
}
