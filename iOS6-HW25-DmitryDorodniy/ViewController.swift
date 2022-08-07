import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!

    private let network = NetworkManager()
    private let urlConstructor = URLConstructor()
    private var timer: Timer?
    private var comics: [Comic] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Marvel Digital Comics"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        setupSearchBar()
        setupTableView()
        fetchComics(from: urlConstructor.getUrl(name: nil, value: nil))
    }

    // MARK: - Settings Views
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search by title..."
        searchController.searchBar.delegate = self
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"),
                                      style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Private functions

    private func fetchComics(from url: String) {
        network.fetchSeries(from: url) { (result) in
            switch result {
            case .success(let comics):
                self.comics = comics
                self.tableView.reloadData()
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                self.showAlert(title: "Request error", message: error.localizedDescription)
            }
        }
    }

    private func getImage(path: String?, size: ImageSize, extention: String?) -> UIImage? {

        if let path = path, let extention = extention {
            let url = path.makeHttps + size.set + extention
            if let imageUrl = URL(string: url),
               let  imageData = try? Data(contentsOf: imageUrl) {
                return UIImage(data: imageData)
            } else {
                return UIImage(systemName: "photo.artframe")
            }
        }
        return UIImage(systemName: "photo.artframe")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comic = comics[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? TableViewCell else { return UITableViewCell() }
        let image = getImage(path: comic.thumbnail?.path,
                             size: .small,
                             extention: comic.thumbnail?.imageExtension)
        
        cell.configureWith(comic, image: image)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comic = comics[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }

        detailVC.view.backgroundColor = .systemBackground
        let image = getImage(path: comic.thumbnail?.path,
                             size: .portrait,
                             extention: comic.thumbnail?.imageExtension)
        detailVC.configureWith(comic, image: image)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { return }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in
            self.fetchComics(from: self.urlConstructor.getUrl(name: "title", value: searchText))
            if self.comics.isEmpty {
                self.showAlert(title: "Title error", message: "Character not found")
            }
        })
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchComics(from: urlConstructor.getUrl(name: nil, value: nil))
    }
}




