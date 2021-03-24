import UIKit

extension UITextField {

    static func newTextField(autoresizingConstraints: Bool = false,
                             fontSize: CGFloat = 16,
                             fontColor: UIColor = .titleColor,
                             borderStyle: BorderStyle = .roundedRect) -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = autoresizingConstraints
        field.font = UIFont.systemFont(ofSize: fontSize)
        field.textColor = fontColor
        field.borderStyle = borderStyle
        return field
    }
}
