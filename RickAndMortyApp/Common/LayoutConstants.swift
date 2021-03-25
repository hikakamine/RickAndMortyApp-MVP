import UIKit

struct LayoutConstants {

    static var cornerRadius: CGFloat = 8.0

    static var sectionInsets = UIEdgeInsets(top: 16,
                                            left: 16,
                                            bottom: 16,
                                            right: 16)

    static var itemsPerRow: CGFloat {
        get {
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                return itemsPerRowForIpad
            default:
                return itemsPerRowForIphone
            }
        }
    }

    static private var itemsPerRowForIpad: CGFloat {
        get {
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown:
                return 4
            default:
                return 5
            }
        }
    }

    static private var itemsPerRowForIphone: CGFloat = 2
}
