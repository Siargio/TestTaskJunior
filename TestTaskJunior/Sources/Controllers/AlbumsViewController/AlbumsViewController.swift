import UIKit

class AlbumsViewController: UIViewController {

    var albums = [Album]()
    var timer: Timer?

    // MARK: - UIElements

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AlbumsTableViewCell.self, forCellReuseIdentifier: Metric.cell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setNavigationBar()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setups

    func setupHierarchy() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
    }
    
    
    private func setNavigationBar() {
        navigationItem.title = Metric.navigationItemTitle
        navigationItem.searchController = searchController
        
        let userInfoButton = createCustomButton(selector: #selector(userInfoButtonTapped))
        navigationItem.rightBarButtonItem = userInfoButton
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = Metric.placeholder
        searchController.obscuresBackgroundDuringPresentation = false
    }

    @objc private func userInfoButtonTapped() {
        let userInfoViewController = UserInfoViewController()
        navigationController?.pushViewController(userInfoViewController, animated: true)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchAlbums(albumName: String) {

        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"

        NetworkDataFetch.shared.fetchAlbum(urlString: urlString) { [weak self] albumModel, error in
            if error == nil {
                guard let albumModel = albumModel else { return }
                if albumModel.results != [] {
                    let sortedAlbums = albumModel.results.sorted { firstItem, secondItem in
                        return firstItem.collectionName.compare(secondItem.collectionName) == ComparisonResult.orderedAscending
                    }
                    self?.albums = sortedAlbums
                    self?.tableView.reloadData()
                }else {
                    self?.alertOk(title: Metric.error, message: Metric.errorMessage)
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Metric.cell, for: indexPath) as! AlbumsTableViewCell
        let album = albums[indexPath.row]
        cell.configureAlbumCell(album: album)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Metric.heightForRowAt
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailAlbumViewController = DetailAlbumViewController()
        let album = albums[indexPath.row]
        detailAlbumViewController.album = album
        detailAlbumViewController.title = album.artistName
        navigationController?.pushViewController(detailAlbumViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension AlbumsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        if text != "" {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: Metric.timeInterval, repeats: false, block: { [weak self ] _ in self?.fetchAlbums(albumName: text ?? "")
            })
        }
    }
}

//MARK: - Metric

extension AlbumsViewController {
    enum Metric  {
        static let heightForRowAt: CGFloat = 70
        static let timeInterval = 0.5

        static let cell = "cell"
        static let navigationItemTitle = "Albums"
        static let placeholder = "Search"
        static let error = "Error"
        static let errorMessage = "Album no found. Add some words"
    }
}
