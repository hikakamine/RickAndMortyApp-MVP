import UIKit

extension UIScrollView {

    func resetScrollPosition() {
        self.setContentOffset(CGPoint(x: -safeAreaInsets.left,
                                      y: -safeAreaInsets.top),
                              animated: true)
    }
}
