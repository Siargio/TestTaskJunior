import UIKit

class SongsCollectionViewCell: UICollectionViewCell {

    // MARK: - UIElements

    let nameSongLabel = UILabel(font: Metric.fontAlbumNameLabel)

    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func setupHierarchy() {
        self.addSubview(nameSongLabel)
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            nameSongLabel.topAnchor.constraint(equalTo: self.topAnchor),
            nameSongLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metric.nameSongLabelLeadingAnchor),
            nameSongLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Metric.nameSongLabelTrailingAnchor),
            nameSongLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

//MARK: - Metric

extension SongsCollectionViewCell {

    enum Metric  {
        static let fontAlbumNameLabel: Int = 18
        static let nameSongLabelLeadingAnchor: CGFloat = 5
        static let nameSongLabelTrailingAnchor: CGFloat = -5
    }
}
