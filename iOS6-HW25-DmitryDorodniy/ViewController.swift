import UIKit

class ViewController: UIViewController {

    private let network = NetworkManager()
    private let urlConstructor = URLConstructor()
    private var timer: Timer?
    private var comics: [Comic] = []

    @IBOutlet weak var tableView: UITableView!
//    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Constants.navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        setupSearchBar()
        setupTableView()
        fetchComics(from: urlConstructor.getUrl(name: nil, value: nil))
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
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

    private func getImage(url: String) -> UIImage? {
        if let imageUrl = URL(string: url),
           let  imageData = try? Data(contentsOf: imageUrl) {
            return UIImage(data: imageData)
        } else {
            return UIImage(systemName: "photo.artframe")
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? TableViewCell else { return UITableViewCell() }
        var content = cell.defaultContentConfiguration()

        content.text = "\(comics[indexPath.row].title)"
        let image = getImage(url: (comics[indexPath.row].thumbnail?.path.makeUrlThumb ?? "") +
                             (comics[indexPath.row].thumbnail?.imageExtension ?? ""))
        content.image = image
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(comics[indexPath.row].title)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }

        detailVC.view.backgroundColor = .systemBackground
        let image = getImage(url: (comics[indexPath.row].thumbnail?.path.makeUrlPortrait ?? "") +
                             (comics[indexPath.row].thumbnail?.imageExtension ?? ""))
        detailVC.portraitImageView.image = image
        detailVC.nameLabel.text = comics[indexPath.row].title
        detailVC.detailLabel.text = comics[indexPath.row].description

        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let inputedText = searchText.replacingOccurrences(of: " ", with: "%20")

        fetchComics(from: urlConstructor.getUrl(name: "title", value: inputedText))

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in

            self.fetchComics(from: self.urlConstructor.getUrl(name: "title", value: inputedText))
            if 
        }
        )
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchComics(from: Constants.marvelDigitalComics)
    }
}



