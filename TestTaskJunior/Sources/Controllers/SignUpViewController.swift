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

    private let loginLabel = UILabel(text: Metric.loginLabelText, font: Metric.fontLoginLabel)
    private let firstNameTextField = UITextField.attributedTextField(text: Metric.firstNameTextFieldText, isSecureTextEntry: false)
    private let firstNameValidLabel = UILabel(text: Metric.requiredFieldText, font: Metric.fontRequiredField)
    private let secondNameTextField = UITextField.attributedTextField(text: Metric.secondNameTextFieldText, isSecureTextEntry: false)
    private let secondNameValidLabel = UILabel(text: Metric.requiredFieldText, font: Metric.fontRequiredField)
    private let ageValidLabel = UILabel(text: Metric.requiredFieldText, font: Metric.fontRequiredField)

    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Phone"
        textField.keyboardType = .numberPad
        return textField
    }()

    private let phoneValidLabel = UILabel(text: Metric.requiredFieldText, font: Metric.fontRequiredField)
    private let emailTextField = UITextField.attributedTextField(text: Metric.emailTextFieldText, isSecureTextEntry: false)
    private let emailValidLabel = UILabel(text: Metric.requiredFieldText, font: Metric.fontRequiredField)
    private let passwordTextField = UITextField.attributedTextField(text: Metric.passwordTextFieldText, isSecureTextEntry: true)
    private let passwordValidLabel = UILabel(text: Metric.requiredFieldText, font: Metric.fontRequiredField)

    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle(Metric.signUpButtonText, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = Metric.signInUPButtonCornetRadius
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private func setupDataPicker() {
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.layer.borderColor = #colorLiteral(red: 0.8810099265, green: 0.8810099265, blue: 0.8810099265, alpha: 1)
        datePicker.layer.borderWidth = Metric.datePickerLayerBorderWidth
        datePicker.clipsToBounds = true
        datePicker.layer.cornerRadius = Metric.datePickerLayerCornerRadius
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
            && phoneText.count == Metric.phoneTextCount
            && ageIsValid() == true {

            DataBase.shard.saveUser(firstName: firstNameText,
                                    secondName: secondNameText,
                                    phone: phoneText,
                                    email: emailText,
                                    password: passwordText,
                                    age: datePicker.date)
            loginLabel.text = Metric.loginLabelTextRegistrationComplete
        } else {
            loginLabel.text = Metric.loginLabelText
            alertOk(title: Metric.errorText, message: Metric.errorTextMessage)
        }
    }

    // MARK: - Setups

    func setupHierarchy() {
        title = Metric.signUpButtonText
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
                                        spacing: Metric.stackViewSpacing,
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

        if result.count == Metric.phoneTextCount {
            phoneValidLabel.text = Metric.phoneValidLabelText
            phoneValidLabel.textColor = .systemGreen
        } else {
            phoneValidLabel.text = Metric.phoneValidLabelTextNot
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
        return (ageUser < Metric.phoneTextCount ? false : true)
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
            elementsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Metric.buttonAndTextFieldsStackViewLeading),
            elementsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: Metric.buttonAndTextFieldsStackViewTrailing),

            loginLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: elementsStackView.topAnchor, constant: Metric.loginLabelBottomAnchor),

            signUpButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: elementsStackView.bottomAnchor, constant: Metric.signUpButtonTopAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: Metric.buttonHeightSingInUp),
            signUpButton.widthAnchor.constraint(equalToConstant: Metric.signUpButtonWidthAnchor)
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
            validMessage: Metric.validMessage,
            wrongMassage: Metric.wrongMassage,
            string: string,
            range: range)
        case secondNameTextField: setTextField(
            textField: secondNameTextField,
            label: secondNameValidLabel,
            validType: nameValidType,
            validMessage: Metric.validMessage,
            wrongMassage: Metric.wrongMassage,
            string: string,
            range: range)
        case emailTextField: setTextField(
            textField: emailTextField,
            label: emailValidLabel,
            validType: emailValueType,
            validMessage: Metric.validMessageEmail,
            wrongMassage: Metric.wrongMassageEmail,
            string: string,
            range: range)
        case passwordTextField: setTextField(
            textField: passwordTextField,
            label: passwordValidLabel,
            validType: passwordValueType,
            validMessage: Metric.validMessagePassword,
            wrongMassage: Metric.wrongMassagePassword,
            string: string,
            range: range)
        case phoneNumberTextField: phoneNumberTextField.text = setPhoneNumberMask(
            texField: phoneNumberTextField,
            mask: Metric.mask,
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

//MARK: - Metric

extension SignUpViewController {

    enum Metric  {
        static let stackViewSpacing: CGFloat = 10
        static let fontRequiredField: Int = 13
        static let datePickerLayerBorderWidth: CGFloat = 1
        static let datePickerLayerCornerRadius: CGFloat = 6
        static let loginLabelBottomAnchor: CGFloat = -30
        static let signUpButtonTopAnchor: CGFloat = 30
        static let signUpButtonWidthAnchor: CGFloat = 300
        static let signInUPButtonCornetRadius: CGFloat = 10
        static let fontLoginLabel: Int = 25
        static let buttonAndTextFieldsStackViewLeading: CGFloat = 20
        static let buttonAndTextFieldsStackViewTrailing: CGFloat = -20
        static let buttonHeightSingInUp: CGFloat = 40
        static let phoneTextCount: Int = 18

        static let loginLabelText: String = "Registration"
        static let firstNameTextFieldText: String = "First Name"
        static let requiredFieldText: String = "Required field"
        static let secondNameTextFieldText: String = "Second Name"
        static let emailTextFieldText: String = "E-mail"
        static let passwordTextFieldText = "Password"
        static let signUpButtonText = "SignUP"
        static let loginLabelTextRegistrationComplete = "Registration complete"
        static let errorText = "Error"
        static let errorTextMessage = "Fill in all the filds and age must me 18+ y.o."
        static let phoneValidLabelText = "Phone is valid"
        static let phoneValidLabelTextNot = "Phone is not valid"
        static let validMessage = "Name is valid"
        static let wrongMassage = "Only A-Z characters, min 1 character"
        static let validMessageEmail = "Email is valid"
        static let wrongMassageEmail = "Email is not valid"
        static let validMessagePassword = "Password is valid"
        static let wrongMassagePassword = "Password is not valid"
        static let mask = "+X (XXX) XXX-XX-XX"
    }
}
