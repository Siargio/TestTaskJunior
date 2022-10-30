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

    private let albumNameLabel = UILabel(text: "Name album name", font: Metric.fontAlbumsTableViewCellAlbumName)

    private let artistNameLabel = UILabel(text: "Name artist name", font: Metric.fontAlbumsTableViewCellArtistAndTrack)

    private let trackCountLabel = UILabel(text: "16 tracks", font: Metric.fontAlbumsTableViewCellArtistAndTrack)

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

    //MARK: - Setups

    func configureAlbumCell(album: Album) { //обращаемся в ссылке на картинку, дату передаем в картинку и присваиваем, если нет то нил

        if let urlString = album.artworkUrl100 {
            NetworkRequest.shared.requestData(urlString: urlString) { [weak self] result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self?.albumLogo.image = image
                case .failure(let error):
                    self?.albumLogo.image = nil
                    print("No album logo" + error.localizedDescription)
                }
            }
        } else {
            albumLogo.image = nil
        }
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        trackCountLabel.text = "\(album.trackCount) track"
    }
    
    private func setupHierarchy() {
        self.backgroundColor = .clear
        self.selectionStyle = .none

        self.addSubview(albumLogo)
        self.addSubview(albumNameLabel)

        stackView = UIStackView(arrangedSubviews: [artistNameLabel, trackCountLabel],
                                axis: .horizontal,
                                spacing: Metric.stackViewSpacing,
                                distribution: .equalCentering)
        self.addSubview(stackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            albumLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            albumLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metric.AlbumsTableViewCellAlbumLogoLeadingAnchor),
            albumLogo.heightAnchor.constraint(equalToConstant: Metric.AlbumsTableViewCellAlbumLogoHeightAndWightAnchor),
            albumLogo.widthAnchor.constraint(equalToConstant: Metric.AlbumsTableViewCellAlbumLogoHeightAndWightAnchor),

            albumNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Metric.AlbumsTableViewCellAlbumNameLabelTopAnchor),
            albumNameLabel.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: Metric.AlbumsTableViewCellAlbumLogoLeadingAnchor),
            albumNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Metric.AlbumsTableViewCellAlbumNameLabelTrailingAnchor),

            stackView.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: Metric.AlbumsTableViewCellStackViewTopAnchor),
            stackView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: Metric.AlbumsTableViewCellStackViewLeadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Metric.AlbumsTableViewCellStackViewTrailingAnchor)
        ])
    }
}
