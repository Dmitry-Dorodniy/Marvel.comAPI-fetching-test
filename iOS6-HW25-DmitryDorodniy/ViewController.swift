//
//  ViewController.swift
//  iOS6-HW25-DmitryDorodniy
//
//  Created by Dmitry Dorodniy on 04.08.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

let network = NetworkManager()
//    let marvelComicsUrl = "https://gateway.marvel.com:443/v1/public/comics?dateDescriptor=thisMonth&ts=1&apikey=7e1b58c9e3967cddad472e676e668a4e&hash=56ea6ee528ff5b2a8724f7a312bcc6f6"
//    let marvel50Characters = "https://gateway.marvel.com:443/v1/public/characters?series=9085&limit=50&ts=1&apikey=7e1b58c9e3967cddad472e676e668a4e&hash=56ea6ee528ff5b2a8724f7a312bcc6f6"
//    var marvelImage = "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784"

    var comics: [Comic] = []

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Marvel Digital Comics"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        setupSearchBar()
        setupTableView()
//        fetchSeries(from: Constants.marvelDigitalComics)
        fetchComics(from: Constants.marvelDigitalComics)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }

    private func fetchComics(from url: String) {
        network.fetchSeries(from: url) { result in
            switch result {
            case .success(let comics):
                self.comics = comics
                self.tableView.reloadData()
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
            }
        }
    }
    private func fetchSeries(from url: String) {

        AF.request(url).responseDecodable(of: DataMarvel.self) { data in
            guard let dataValue = data.value else {
                print("no data")
                return }

            DispatchQueue.main.async {
                let comics = dataValue.data.results
                self.comics = comics
                self.tableView.reloadData()
            }
        }
    }
}

private func getImage(url: String) -> UIImage? {
    if let imageUrl = URL(string: url),
       let  imageData = try? Data(contentsOf: imageUrl) {
        return UIImage(data: imageData)
    } else {
       return UIImage(named: "square-image")
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        var content = cell.defaultContentConfiguration()

        content.text = "\(comics[indexPath.row].title)"
//        content.textProperties.font =
//        content.secondaryText = "issue number: \(Int(comics[indexPath.row].issueNumber ?? 0))"
//        content.secondaryTextProperties.color = .secondaryLabel
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
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController

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
        print(inputedText)

        let urlString = "https://gateway.marvel.com:443/v1/public/comics?format=comic&title=\(inputedText)&formatType=comic&hasDigitalIssue=true&orderBy=focDate&limit=100&ts=1&apikey=7e1b58c9e3967cddad472e676e668a4e&hash=56ea6ee528ff5b2a8724f7a312bcc6f6"

        print(urlString)
        print(inputedText)
        fetchSeries(from: urlString)

//        timer?.invalidate()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
//
//            self.networkDataFetcher.fetchTracks(urlString: urlString) { searchResponse in
//                guard let searchResponse = searchResponse else {
//                    return
//                }
//                _ = searchResponse.results.map { track in
//                    print("track name: \(track.trackName)")
//                }
//                self.searchResponse = searchResponse
//                self.table.reloadData()
//            }
//            //        self.networkDataFetcher.fetchTracks(urlString: urlString) { searchResponse in
//            //            guard let searchResponse = searchResponse else {
//            //                return
//            //            }
//            //            searchResponse.results.map { track in
//            //                print("track name: \(track.trackName)")
//            //            }
//            //            self.searchResponse = searchResponse
//            //            self.table.reloadData()
//            //        }
//
//        }
//        )
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchSeries(from: Constants.marvelDigitalComics)
    }
}



