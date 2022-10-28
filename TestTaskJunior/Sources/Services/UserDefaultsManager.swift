import Foundation

class DataBase {

    static let shard = DataBase()

    enum SettingKeys: String {
        case users
        case activeUser
    }

    let defaults = UserDefaults.standard
    let userKey = SettingKeys.users.rawValue
    let activeUserKey = SettingKeys.activeUser.rawValue

    var users: [User] {
        get {
            if let data = defaults.value(forKey: userKey) as? Data { //запрашиваем по ключу дату и проверям
                return try! PropertyListDecoder().decode([User].self, from: data) // декодируем в модель User
            } else {
                return [User]() //если не получилось возвращаем пустой User
            }
        }

        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: userKey)
            }
        }
    }

    func saveUser(firstName: String, secondName: String, phone: String, email: String, password: String, age: Date) {
        let user = User(firstName: firstName, secondName: secondName, phone: phone, email: email, password: password, age: age)
        users.insert(user, at: 0)
    }

    var activeUser: User? {
        get {
            if let data = defaults.value(forKey: activeUserKey) as? Data { //запрашиваем по ключу дату и проверям
                return try! PropertyListDecoder().decode(User.self, from: data) // декодируем в модель User
            } else {
                return nil //если не получилось возвращаем пустой User
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: activeUserKey)
            }
        }
    }
    func saveActiveUser(user: User) {
        activeUser = user
    }
}
