import UIKit

struct LayoutConstants {

    struct CharactersCollection {
        var cornerRadius: CGFloat = 8.0

        var sectionInsets = UIEdgeInsets(top: 16,
                                         left: 16,
                                         bottom: 16,
                                         right: 16)

        var itemsPerRow: Int {
            get {
                switch UIDevice.current.userInterfaceIdiom {
                case .pad:
                    return itemsPerRowForIpad
                default:
                    return itemsPerRowForIphone
                }
            }
        }

        private var itemsPerRowForIpad: Int {
            get {
                switch UIApplication.shared.statusBarOrientation {
                case .portrait, .portraitUpsideDown:
                    return 4
                default:
                    return 5
                }
            }
        }

        private var itemsPerRowForIphone: Int = 2

        func collectionCellViewSize(widthSize width: CGFloat) -> CGSize {
            let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 2)
            let availableWidth = width - paddingSpace
            let widthPerItem = (availableWidth / CGFloat(itemsPerRow)) + 8
            let size =  CGSize(width: widthPerItem,
                               height: widthPerItem + 36)
            return size
        }

        func loadingViewSize(widthSize width: CGFloat) -> CGSize {
            return CGSize(width: width,
                          height: 60)
        }
    }
}
