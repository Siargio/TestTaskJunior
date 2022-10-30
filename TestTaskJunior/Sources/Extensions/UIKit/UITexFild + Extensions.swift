import UIKit

extension UITextField {

    class func attributedTextField(text: String = "", isSecureTextEntry: Bool) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.leftViewMode = .always
        textField.clearButtonMode = .always // кнопка удалить текст
        textField.returnKeyType = .done
        textField.placeholder = text
        textField.isSecureTextEntry = isSecureTextEntry
        return textField
    }
}
