import UIKit

class DetailAlbumViewController: UIViewController {

    // MARK: - UIElements
    
    private let albumLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let albumNameLabel = UILabel(text: "Name album", font: Metric.fontAlbumNameLabel)

    private let artistNameLabel = UILabel(text: "Name artist", font: Metric.fontAlbumNameLabel)

    private let releaseDateLabel = UILabel(text: "Release date", font: Metric.fontAlbumNameLabel)

    private let trackCountLabel = UILabel(text: "10 tracks", font: Metric.fontAlbumNameLabel)

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Metric.collectionViewLayout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.register(SongsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var stackView = UIStackView()

    var album: Album?
    var songs = [Song]()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setDelegate()
        setModel()
        fetchSong(album: album)
    }

    // MARK: - Setups

    private func setupHierarchy() {
        view.backgroundColor = .white
        view.addSubview(albumLogo)

        stackView = UIStackView(arrangedSubviews: [albumNameLabel,
                                                   artistNameLabel,
                                                   releaseDateLabel,
                                                   trackCountLabel],
                                axis: .vertical,
                                spacing: Metric.stackViewSpacing,
                                distribution: .fillProportionally)

        view.addSubview(stackView)
        view.addSubview(collectionView)
    }

    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setModel() {
        guard let album = album else { return }

        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        trackCountLabel.text = "\(album.trackCount) tracks:"
        releaseDateLabel.text = setDateFormat(date: album.releaseDate)

        guard let url = album.artworkUrl100 else { return }
        setImage(urlString: url)
    }

    private func setDateFormat(date: String) -> String { // добавляет дату в описании альбома

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let backendDate = dateFormatter.date(from: date) else { return "" }

        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let date = formatDate.string(from: backendDate)
        return date
    }

    private func setImage(urlString: String?) { // добавляет картинку в описании альбома

        if let url = urlString {
            NetworkRequest.shared.requestData(urlString: url) { [weak self] result in
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
    }

    private func fetchSong(album: Album?) { // добавляет список треков в описании альбома

        guard let album = album else { return }
        let idAlbum = album.collectionId
        let urlString = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"
      
        NetworkDataFetch.shared.fetchSongs(urlString: urlString) { [weak self ] songModel, error in
            if error == nil {
                guard let songModel = songModel else { return }
                self?.songs = songModel.results
                self?.collectionView.reloadData()
            } else {
                print(error!.localizedDescription)
                self?.alertOk(title: "Error", message: error!.localizedDescription)
            }
        }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            albumLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.albumLogoTopAnchor),
            albumLogo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.albumLogoLeadingAnchor),
            albumLogo.heightAnchor.constraint(equalToConstant: Metric.albumLogoHeightAndWidthAnchor),
            albumLogo.widthAnchor.constraint(equalToConstant: Metric.albumLogoHeightAndWidthAnchor),

            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.stackViewTopAnchor),
            stackView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: Metric.buttonAndTextFieldsStackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.buttonAndTextFieldsStackViewTrailing),

            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: albumLogo.trailingAnchor, constant: Metric.collectionViewLeadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.collectionViewTrailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Metric.collectionViewBottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate

extension DetailAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        songs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SongsCollectionViewCell
        let song = songs[indexPath.row].trackName
        cell.nameSongLabel.text = song
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: Metric.collectionViewHeight)
    }
}
