import Foundation
// предикаты проверка на валидность
// расширение для строки при помощи предиката фильтруем строку
extension String {

    enum ValidTypes {
        case name
        case email
        case password
    }

    enum RegEx: String {
        case name = "[a-zA-Z]{1,}"
        case email = "[a-zA-Z0-9._]+@[a-zA-Z0-9]+\\.[a-zA-Z]{2,}"
        case password = "(?=.*[A-Z])(?=.*[A-Z])(?=.*[0-9]).{6,}"
    }

    func isValid(validType: ValidTypes) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""

        switch validType {
        case .name: regex = RegEx.name.rawValue
        case .email: regex = RegEx.email.rawValue
        case .password: regex = RegEx.password.rawValue
        }

        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
