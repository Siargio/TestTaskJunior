import UIKit

class UserInfoViewController: UIViewController {

    // MARK: - UIElements

    private let firstNameLabel = UILabel(text: Metric.firstNameLabelText, font: Metric.fontLabelUserInfoViewController)
    private let secondNameLabel = UILabel(text: Metric.secondNameLabelText, font: Metric.fontLabelUserInfoViewController)
    private let ageLabel = UILabel(text: Metric.ageLabelText, font: Metric.fontLabelUserInfoViewController)
    private let phoneLabel = UILabel(text: Metric.phoneLabelText, font: Metric.fontLabelUserInfoViewController)
    private let emailLabel = UILabel(text: Metric.emailLabelText, font: Metric.fontLabelUserInfoViewController)
    private let passwordLabel = UILabel(text: Metric.passwordLabelText, font: Metric.fontLabelUserInfoViewController)
    private var stackView = UIStackView()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
        setModel()
    }

    // MARK: - Setups

    private func setupHierarchy() {
        title = Metric.title
        view.backgroundColor = .white

        stackView = UIStackView(arrangedSubviews: [firstNameLabel,
                                                   secondNameLabel,
                                                   ageLabel,
                                                   phoneLabel,
                                                   emailLabel,
                                                   passwordLabel],
                                axis: .vertical,
                                spacing: Metric.stackViewSpacing,
                                distribution: .fillProportionally)

        view.addSubview(stackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.buttonAndTextFieldsStackViewTrailing),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.buttonAndTextFieldsStackViewLeading),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setModel() {
        guard let activeUser = DataBase.shard.activeUser else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Metric.dateFormat
        let dateString = dateFormatter.string(from: activeUser.age)

        firstNameLabel.text = activeUser.firstName
        secondNameLabel.text = activeUser.secondName
        phoneLabel.text = activeUser.phone
        emailLabel.text = activeUser.email
        passwordLabel.text = activeUser.password
        ageLabel.text = dateString
    }
}

//MARK: - Metric

extension UserInfoViewController {
    enum Metric  {
        static let fontLabelUserInfoViewController: Int = 20
        static let stackViewSpacing: CGFloat = 10
        static let buttonAndTextFieldsStackViewLeading: CGFloat = 20
        static let buttonAndTextFieldsStackViewTrailing: CGFloat = -20

        static let firstNameLabelText = "First Name"
        static let secondNameLabelText = "Second Name"
        static let ageLabelText = "Age"
        static let phoneLabelText = "Phone"
        static let emailLabelText = "Email"
        static let passwordLabelText = "Password"
        static let title = "Active User"
        static let dateFormat = "dd.MM.yyyy"
    }
}
