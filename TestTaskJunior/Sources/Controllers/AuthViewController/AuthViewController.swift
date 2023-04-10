import UIKit

class AuthViewController: UIViewController {

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
    private let emailTextField = UITextField.attributedTextField(text: Metric.emailTextFieldText, isSecureTextEntry: false)
    private let passwordTextField = UITextField.attributedTextField(text: Metric.passwordTextFieldText, isSecureTextEntry: true)

    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Metric.signInButtonSetTitle, for: .normal)
        button.backgroundColor = UIColor(named: Metric.signInButtonBackgroundColor)
        button.tintColor = .white
        button.layer.cornerRadius = Metric.signInUPButtonCornetRadius
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Metric.signUpButtonSetTitle, for: .normal)
        button.backgroundColor = UIColor(named: Metric.signUnButtonBackgroundColor)
        button.tintColor = .white
        button.layer.cornerRadius = Metric.signInUPButtonCornetRadius
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupDelegate()
        registerKeyboardNotification()
    }

    deinit {
        removeKeyboardNotification()
    }

    // MARK: - Action

    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @objc private func signUpButtonTapped() {
        let signUpViewController = SignUpViewController()
        present(signUpViewController, animated: true)
    }

    @objc private func signInButtonTapped() {

        let mail = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let user = findUserDataBase(mail: mail)

        if user == nil {
            loginLabel.text = Metric.buttonLoginLabelText
            loginLabel.textColor = .red
        } else if user?.password == password {
            let navVC = UINavigationController(rootViewController: AlbumsViewController())
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
            guard let activeUser = user else { return }
            DataBase.shard.saveActiveUser(user: activeUser)
        } else {
            loginLabel.text = Metric.buttonLoginLabelTextWrong
            loginLabel.textColor = .red
        }
    }

    private func findUserDataBase(mail: String) -> User? { // пробегаемся находим пользователя проверяем почту, если почта равно той которую мы ввели то на выходе возвращаем юзера если нет то нил
        let dataBase = DataBase.shard.users
        print(dataBase)

        for user in dataBase {
            if user.email == mail {
                return user
            }
        }
        return nil
    }

    // MARK: - Setups

    private var textFieldsStackView = UIStackView()
    private var buttonsStackView = UIStackView()
    private var stackViewTextViewAndButtonView = UIStackView()

    func setupHierarchy() {
        title = Metric.setupHierarchyTitle
        textFieldsStackView = UIStackView(arrangedSubviews:
                                            [emailTextField, passwordTextField],
                                          axis: .vertical,
                                          spacing: Metric.stackViewSpacing,
                                          distribution: .fillProportionally)

        buttonsStackView = UIStackView(arrangedSubviews:
                                        [signInButton, signUpButton],
                                       axis: .horizontal,
                                       spacing: Metric.stackViewSpacing,
                                       distribution: .fillEqually)

        view.addSubview(scrollView)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(textFieldsStackView)
        backgroundView.addSubview(loginLabel)
        backgroundView.addSubview(buttonsStackView)
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

            textFieldsStackView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            textFieldsStackView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textFieldsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Metric.buttonAndTextFieldsStackViewLeading),
            textFieldsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: Metric.buttonAndTextFieldsStackViewTrailing),

            loginLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: textFieldsStackView.topAnchor, constant: Metric.loginLabelBottom),

            signUpButton.heightAnchor.constraint(equalToConstant: Metric.buttonHeightSingInUp),
            signInButton.heightAnchor.constraint(equalToConstant: Metric.buttonHeightSingInUp),

            buttonsStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Metric.buttonAndTextFieldsStackViewLeading),
            buttonsStackView.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: Metric.buttonsStackViewTopAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: Metric.buttonAndTextFieldsStackViewTrailing),
        ])
    }
}

//MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
}

//MARK: - Keyboard Show Hide // поднимает над клавиатурой когда нажимаешь на текстфилд

extension AuthViewController {

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

extension AuthViewController {

    enum Metric  {
        static let fontLoginLabel: Int = 25
        static let signInUPButtonCornetRadius: CGFloat = 10
        static let stackViewSpacing: CGFloat = 10
        static let buttonAndTextFieldsStackViewLeading: CGFloat = 20
        static let buttonAndTextFieldsStackViewTrailing: CGFloat = -20
        static let loginLabelBottom: CGFloat = -30
        static let buttonHeightSingInUp: CGFloat = 40
        static let buttonsStackViewTopAnchor: CGFloat = 30

        static let loginLabelText: String = "Login"
        static let emailTextFieldText: String = "Enter email"
        static let passwordTextFieldText: String = "Enter password"
        static let signInButtonSetTitle: String = "SingIn"
        static let signInButtonBackgroundColor: String = "buttonIn"
        static let signUpButtonSetTitle: String = "SingUp"
        static let signUnButtonBackgroundColor: String = "buttonUp"
        static let buttonLoginLabelText: String = "User not found"
        static let buttonLoginLabelTextWrong: String = "Wrong password"
        static let setupHierarchyTitle: String = "SingIn"
    }
}
