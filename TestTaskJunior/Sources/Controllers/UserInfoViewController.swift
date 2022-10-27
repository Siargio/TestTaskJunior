import UIKit

class UserInfoViewController: UIViewController {

    // MARK: - UIElements

    private let firstNameLabel = UILabel(text: "First Name", font: 17)

    private let secondNameLabel = UILabel(text: "Second Name", font: 17)

    private let ageLabel = UILabel(text: "Age", font: 17)

    private let phoneLabel = UILabel(text: "Phone", font: 17)

    private let emailLabel = UILabel(text: "Email", font: 17)

    private let passwordLabel = UILabel(text: "Password", font: 17)

    private var stackView = UIStackView()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
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
                                spacing: 10,
                                distribution: .fillProportionally)

        view.addSubview(stackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
