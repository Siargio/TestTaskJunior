import UIKit

class SignUpViewController: UIViewController {

    // MARK: - UIElements

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loginLabel = UILabel(text: "Registration", font: 17)

    private let firstNameTextField = UITextField.attributedTextField(text: "First Name")

    private let firstNameValidLabel = UILabel(text: "Required field", font: 14)

    private let secondNameTextField = UITextField.attributedTextField(text: "Second Name")

    private let secondNameValidLabel = UILabel(text: "Required field", font: 14)

    private let ageValidLabel = UILabel(text: "Required field", font: 14)

    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Phone"
        textField.keyboardType = .numberPad
        return textField
    }()

    private let phoneValidLabel = UILabel(text: "Required field", font: 14)

    private let emailTextField = UITextField.attributedTextField(text: "E-mail")

    private let emailValidLabel = UILabel(text: "Required field", font: 14)

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        return textField
    }()

    private let passwordValidLabel = UILabel(text: "Required field", font: 14)

    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("SignUP", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func setupDataPicker() {
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.layer.borderColor = #colorLiteral(red: 0.8810099265, green: 0.8810099265, blue: 0.8810099265, alpha: 1)
        datePicker.layer.borderWidth = 1
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = 6
        datePicker.tintColor = .black
    }

    private var elementsStackView = UIStackView()
    private let datePicker = UIDatePicker()

    let nameValidType: String.ValidTypes = .name
    let emailValueType: String.ValidTypes = .email
    let passwordValueType: String.ValidTypes = .password

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupDataPicker()
        registerKeyboardNotification()
    }

    deinit {
        removeKeyboardNotification()
    }
    
    // MARK: - Action

    @objc private func signUpButtonTapped() {

        let firstNameText = firstNameTextField.text ?? ""
        let secondNameText = secondNameTextField.text ?? ""
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let phoneText = phoneNumberTextField.text ?? ""

        if firstNameText.isValid(validType: nameValidType)
            && secondNameText.isValid(validType: nameValidType)
            && emailText.isValid(validType: emailValueType)
            && passwordText.isValid(validType: passwordValueType)
            && phoneText.count == 18
            && ageIsValid() == true {

            DataBase.shard.saveUser(firstName: firstNameText, secondName: secondNameText, phone: phoneText, email: emailText, password: passwordText, age: datePicker.date)
            loginLabel.text = "Registration complete"
        } else {
            loginLabel.text = "Registration"
            alertOk(title: "Error", message: "Fill in all the filds and age must me 18+ y.o.")
        }
    }

    // MARK: - Setups

    func setupHierarchy() {
        title = "SignUp"
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)

        elementsStackView = UIStackView(arrangedSubviews:
                                            [firstNameTextField,
                                             firstNameValidLabel,
                                             secondNameTextField,
                                             secondNameValidLabel,
                                             datePicker,
                                             ageValidLabel,
                                             phoneNumberTextField,
                                             phoneValidLabel,
                                             emailTextField,
                                             emailValidLabel,
                                             passwordTextField,
                                             passwordValidLabel],
                                        axis: .vertical,
                                        spacing: 10,
                                        distribution: .fillProportionally)

        backgroundView.addSubview(elementsStackView)
        backgroundView.addSubview(loginLabel)
        backgroundView.addSubview(signUpButton)
    }

    private func setupDelegate() {
        firstNameTextField.delegate = self
        secondNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func setTextField(textField: UITextField, label: UILabel, validType: String.ValidTypes, validMessage: String, wrongMassage: String, string: String, range: NSRange) {

        let text = (textField.text ?? "") + string
        let result: String

        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        } else {
            result = text
        }

        textField.text = result

        if result.isValid(validType: validType) {
            label.text = validMessage
            label.textColor = .systemGreen
        } else {
            label.text = wrongMassage
            label.textColor = .red
        }
    }

    // проверка номера телефона
    private func setPhoneNumberMask(texField: UITextField, mask: String, string: String, range: NSRange) -> String {

        let text = texField.text ?? ""

        let phone = (text as NSString).replacingCharacters(in: range, with: string)
        let number = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = number.startIndex

        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }

        if result.count == 18 {
            phoneValidLabel.text = "Phone is valid"
            phoneValidLabel.textColor = .systemGreen
        } else {
            phoneValidLabel.text = "Phone is not valid"
            phoneValidLabel.textColor = .red
        }
        return result
    }

    private func ageIsValid() -> Bool {
        let calendar = NSCalendar.current
        let dateNow = Date()
        let birthday = datePicker.date

        let age = calendar.dateComponents([.year], from: dateNow)
        let ageYear = age.year
        guard let ageUser = ageYear else { return false }
        return (ageUser < 18 ? false : true)
    }

    func setupLayout() {

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backgroundView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor),

            elementsStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            elementsStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            elementsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            elementsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),

            loginLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: elementsStackView.topAnchor, constant: -30),

            signUpButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: elementsStackView.bottomAnchor, constant: 30),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
}

//MARK: - UITextFieldDelegate проверка на валидность

extension SignUpViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        switch textField {
        case firstNameTextField: setTextField(
            textField: firstNameTextField,
            label: firstNameValidLabel,
            validType: nameValidType,
            validMessage: "Name is valid",
            wrongMassage: "Only A-Z characters, min 1 character",
            string: string,
            range: range)
        case secondNameTextField: setTextField(
            textField: secondNameTextField,
            label: secondNameValidLabel,
            validType: nameValidType,
            validMessage: "Name is valid",
            wrongMassage: "Only A-Z characters, min 1 character",
            string: string,
            range: range)
        case emailTextField: setTextField(
            textField: emailTextField,
            label: emailValidLabel,
            validType: emailValueType,
            validMessage: "Email is valid",
            wrongMassage: "Email is not valid",
            string: string,
            range: range)
        case passwordTextField: setTextField(
            textField: passwordTextField,
            label: passwordValidLabel,
            validType: passwordValueType,
            validMessage: "Password is valid",
            wrongMassage: "Password is not valid",
            string: string,
            range: range)
        case phoneNumberTextField: phoneNumberTextField.text = setPhoneNumberMask(
            texField: phoneNumberTextField,
            mask: "+X (XXX) XXX-XX-XX",
            string: string,
            range: range)
        default:
            break
        }
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstNameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

//MARK: - Keyboard Show Hide // поднимает над клавиатурой когда нажимаешь на текстфилд

extension SignUpViewController {

    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }

    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height / 2)
    }

    @objc private func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}
