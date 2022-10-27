import UIKit

class AlbumsTableViewCell: UITableViewCell {

    // MARK: - UIElements
    
    private let albumLogo: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let albumNameLabel = UILabel(text: "Name album name", font: 20)

    private let artistNameLabel = UILabel(text: "Name artist name", font: 16)

    private let trackCountLabel = UILabel(text: "16 tracks", font: 16)

    var stackView = UIStackView()

    override func layoutSubviews() {
        super.layoutSubviews() // для того чтобы при загрузке ячейки мы снова перерисовывали для альбома размеры

        albumLogo.layer.cornerRadius = albumLogo.frame.width / 2
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHierarchy() {
        self.backgroundColor = .clear
        self.selectionStyle = .none

        self.addSubview(albumLogo)
        self.addSubview(albumNameLabel)

        stackView = UIStackView(arrangedSubviews: [artistNameLabel, trackCountLabel],
                                axis: .horizontal,
                                spacing: 10,
                                distribution: .equalCentering)
        self.addSubview(stackView)
    }

    private func setupLayout() {

        NSLayoutConstraint.activate([
            albumLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            albumLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            albumLogo.heightAnchor.constraint(equalToConstant: 60),
            albumLogo.widthAnchor.constraint(equalToConstant: 60),

            albumNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            albumNameLabel.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 10),
            albumNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),

            stackView.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
}
