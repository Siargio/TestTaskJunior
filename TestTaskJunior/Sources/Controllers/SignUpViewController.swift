import UIKit

class SignUpViewController: UIViewController {

    // MARK: - UIElements

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

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupDelegate()
        setupDataPicker()
    }
    // MARK: - Action

    @objc private func signUpButtonTapped() {
        print("SignUpTap")
    }

    // MARK: - Setups

    func setupHierarchy() {
        title = "SignUp"
        view.backgroundColor = .white

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

        view.addSubview(elementsStackView)
        view.addSubview(loginLabel)
        view.addSubview(signUpButton)
    }

    func setupLayout() {

        NSLayoutConstraint.activate([
            elementsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            elementsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -106),
            elementsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            elementsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: elementsStackView.topAnchor, constant: -30),

            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: elementsStackView.bottomAnchor, constant: 30),
            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }

    private func setupDelegate() {
        firstNameTextField.delegate = self
        secondNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}

//MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

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
