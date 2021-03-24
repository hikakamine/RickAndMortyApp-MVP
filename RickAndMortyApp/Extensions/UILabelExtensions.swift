import UIKit

extension UILabel {

    static func newLabel(autoresizingConstraints: Bool = false,
                         fontSize: CGFloat = 16,
                         fontColor: UIColor = .titleColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = autoresizingConstraints
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textColor = fontColor
        return label
    }
}
