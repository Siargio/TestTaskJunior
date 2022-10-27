import UIKit

class AuthViewController: UIViewController {

    // MARK: - UIElements

    private let loginLabel = UILabel(text: "Login", font: 25)

    private let emailTextField = UITextField.attributedTextField(text: "Enter email")

    private let passwordTextField = UITextField.attributedTextField(text: "Enter password")

    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SingIn", for: .normal)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SingUp", for: .normal)
        button.backgroundColor = .red
        button.tintColor = .white
        button.layer.cornerRadius = 10
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
        let navVC = UINavigationController(rootViewController: AlbumsViewController())
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true)
    }

    // MARK: - Setups

    private var textFieldsStackView = UIStackView()
    private var buttonsStackView = UIStackView()

    func setupHierarchy() {
        title = "SingIn"
        view.backgroundColor = .white
        textFieldsStackView = UIStackView(arrangedSubviews:
                                            [emailTextField, passwordTextField],
                                          axis: .vertical,
                                          spacing: 10,
                                          distribution: .fillProportionally)

        buttonsStackView = UIStackView(arrangedSubviews:
                                        [signInButton, signUpButton],
                                       axis: .horizontal,
                                       spacing: 10,
                                       distribution: .fillEqually)

        view.addSubview(textFieldsStackView)
        view.addSubview(loginLabel)
        view.addSubview(buttonsStackView)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            textFieldsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            textFieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textFieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.bottomAnchor.constraint(equalTo: textFieldsStackView.topAnchor, constant: -30),

            signUpButton.heightAnchor.constraint(equalToConstant: 40),
            signInButton.heightAnchor.constraint(equalToConstant: 40),

            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
