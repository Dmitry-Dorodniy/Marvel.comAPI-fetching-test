//
//  ViewController.swift
//  iOS6-HW25-DmitryDorodniy
//
//  Created by Dmitry Dorodniy on 04.08.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {


    let marvelComicsUrl = "https://gateway.marvel.com:443/v1/public/comics?dateDescriptor=thisMonth&ts=1&apikey=7e1b58c9e3967cddad472e676e668a4e&hash=56ea6ee528ff5b2a8724f7a312bcc6f6"
    let marvel50Characters = "https://gateway.marvel.com:443/v1/public/characters?series=9085&limit=50&ts=1&apikey=7e1b58c9e3967cddad472e676e668a4e&hash=56ea6ee528ff5b2a8724f7a312bcc6f6"
    var marvelImage = "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784"

    var characters: [Character] = []

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)


    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = .cyan
        navigationItem.title = "Marvel Avengers:"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        setupSearchBar()
        setupTableView()
        fetchSeries(from: marvel50Characters)
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

    private func fetchSeries(from url: String) {

        AF.request(url).responseDecodable(of: DataMarvel.self) { data in
            guard let char = data.value else {
                print("no data")
                return }

            DispatchQueue.main.async {
                let characters = char.data.results
                self.characters = characters
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
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        var content = cell.defaultContentConfiguration()

        content.text = "\(characters[indexPath.row].name)"
//        content.textProperties.font =
        content.secondaryText = "numder of comics: \(characters[indexPath.row].comics.available)"
        content.secondaryTextProperties.color = .secondaryLabel
        let image = getImage(url: characters[indexPath.row].thumbnail.path.makeUrlThumb +
                 characters[indexPath.row].thumbnail.imageExtension)
        content.image = image
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content

return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(characters[indexPath.row].name)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController

        detailVC.view.backgroundColor = .systemBackground
        let image = getImage(url: characters[indexPath.row].thumbnail.path.makeUrlPortrait +
                             characters[indexPath.row].thumbnail.imageExtension)
        detailVC.portraitImageView.image = image
        detailVC.nameLabel.text = characters[indexPath.row].name
        detailVC.detailLabel.text = characters[indexPath.row].description

        navigationController?.pushViewController(detailVC, animated: true)

    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var inputedText = searchText.replacingOccurrences(of: " ", with: "%20")
        print(inputedText)

        let urlString = "https://gateway.marvel.com:443/v1/public/characters?name=\(inputedText)&limit=100&ts=1&apikey=7e1b58c9e3967cddad472e676e668a4e&hash=56ea6ee528ff5b2a8724f7a312bcc6f6"
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
        fetchSeries(from: marvel50Characters)
    }
}



