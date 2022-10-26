import UIKit

extension UILabel {
    convenience init(text: String = "", font: Int) {
        self.init()

        self.text = text
        self.font = UIFont.systemFont(ofSize: CGFloat(font))
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
