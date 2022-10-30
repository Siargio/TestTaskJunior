import UIKit

class SongsCollectionViewCell: UICollectionViewCell {

    // MARK: - UIElements

    let nameSongLabel = UILabel(font: Metric.fontAlbumNameLabel)

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
