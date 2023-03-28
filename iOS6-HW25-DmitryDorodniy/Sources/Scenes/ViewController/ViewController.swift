import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    private lazy var spinnerIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        view.addSubview(spinner)
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private let network = NetworkManager()
    private let urlConstructor = URLConstructor()
    private var timer: Timer?
    private var comics: [Comic] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        fetchComics(from: urlConstructor.getMasterUrl(name: nil,
                                                      value: nil))
    }

    // MARK: - Settings Views

    private func setupView() {
        navigationItem.title = "Marvel Digital Comics"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)

        setupSearchBar()
        setupTableView()
    }
    
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
        spinnerIndicator.startAnimating()
        network.fetchSeries(from: url) { (result) in
            switch result {
            case .success(let comics):
                DispatchQueue.main.async {
                    self.spinnerIndicator.stopAnimating()
                    self.comics = comics
                    if self.comics.isEmpty {
                        self.showAlert(title: ":(", message: "Title not found")
                    }
                    self.tableView.reloadData()
                }

            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                self.showAlert(title: "Request error", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comic = comics[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? TableViewCell
        else { return UITableViewCell() }

        cell.configureWith(comic)

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            comics.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let comic = comics[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        detailVC.view.backgroundColor = .systemBackground
        detailVC.configureWith(comic)
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { return }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.fetchComics(from: self.urlConstructor.getMasterUrl(name: "title", value: searchText))
        })
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchComics(from: urlConstructor.getMasterUrl(name: nil, value: nil))
    }
}




