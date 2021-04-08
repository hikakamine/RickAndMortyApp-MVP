import UIKit

struct LayoutConstants {

    struct CharactersCollection {
        var cornerRadius: CGFloat = 8.0

        var sectionInsets = UIEdgeInsets(top: 16,
                                         left: 16,
                                         bottom: 16,
                                         right: 16)

        private var itemsPerRow: CGFloat {
            get {
                switch UIDevice.current.userInterfaceIdiom {
                case .pad:
                    return itemsPerRowForIpad
                default:
                    return itemsPerRowForIphone
                }
            }
        }

        private var itemsPerRowForIpad: CGFloat {
            get {
                if isInterfaceOrientationPortrait {
                    return 4
                }
                return 5
            }
        }

        private var itemsPerRowForIphone: CGFloat = 2

        private var isInterfaceOrientationPortrait: Bool {
            if #available(iOS 13.0, *) {
                return UIApplication.shared.windows
                    .first?.windowScene?.interfaceOrientation.isPortrait ?? false
            } else {
                return UIApplication.shared.statusBarOrientation.isPortrait
            }
        }

        func collectionCellViewSize(widthSize width: CGFloat) -> CGSize {
            let paddingSpace = sectionInsets.left * (itemsPerRow + 2)
            let availableWidth = width - paddingSpace
            let widthPerItem = (availableWidth / itemsPerRow) + 8
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
