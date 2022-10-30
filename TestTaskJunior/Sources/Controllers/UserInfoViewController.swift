import UIKit

class UserInfoViewController: UIViewController {

    // MARK: - UIElements

    private let firstNameLabel = UILabel(text: "First Name", font: Metric.fontLabelUserInfoViewController)

    private let secondNameLabel = UILabel(text: "Second Name", font: Metric.fontLabelUserInfoViewController)

    private let ageLabel = UILabel(text: "Age", font: Metric.fontLabelUserInfoViewController)

    private let phoneLabel = UILabel(text: "Phone", font: Metric.fontLabelUserInfoViewController)

    private let emailLabel = UILabel(text: "Email", font: Metric.fontLabelUserInfoViewController)

    private let passwordLabel = UILabel(text: "Password", font: Metric.fontLabelUserInfoViewController)

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
        title = "Active User"
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
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: activeUser.age)

        firstNameLabel.text = activeUser.firstName
        secondNameLabel.text = activeUser.secondName
        phoneLabel.text = activeUser.phone
        emailLabel.text = activeUser.email
        passwordLabel.text = activeUser.password
        ageLabel.text = dateString
    }
}
