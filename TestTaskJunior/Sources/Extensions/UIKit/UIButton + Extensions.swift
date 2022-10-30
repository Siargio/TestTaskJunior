import UIKit

//extension UIButton {
//
//    class func attributedButton(text: String = "", backgroundColor: UIColor = .clear, tintColor: UIColor = .clear, selector: Selector) -> UIButton {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle(text, for: .normal)
//        button.backgroundColor = backgroundColor
//        button.tintColor = tintColor
//        button.layer.cornerRadius = 10
//        button.addTarget(self, action: selector, for: .touchUpInside)
//        return button
//    }
//}

extension UIButton {
    convenience init(text: String = "", backgroundColor: UIColor = .clear, tintColor: UIColor = .clear, selector: Selector) {
        self.init()

        self.setTitle(text, for: .normal)
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.layer.cornerRadius = 10
        self.addTarget(self, action: selector, for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

