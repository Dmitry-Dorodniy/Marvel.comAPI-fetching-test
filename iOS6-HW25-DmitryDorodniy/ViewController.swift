//
//  ViewController.swift
//  iOS6-HW25-DmitryDorodniy
//
//  Created by Dmitry Dorodniy on 04.08.2022.
//

import UIKit

class ViewController: UIViewController {


    let marvelComicsUrl = "https://gateway.marvel.com:443/v1/public/comics?dateDescriptor=thisMonth&ts=1&apikey=7e1b58c9e3967cddad472e676e668a4e&hash=56ea6ee528ff5b2a8724f7a312bcc6f6"
    let marvel50Characters = "https://gateway.marvel.com:443/v1/public/characters?&limit=50&ts=1&apikey=7e1b58c9e3967cddad472e676e668a4e&hash=56ea6ee528ff5b2a8724f7a312bcc6f6"
    var marvelImage = "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784"

var characters = [Character]()

    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = .cyan
        navigationItem.title = "Marvel Characters:"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let image = marvelImage.makeUrlForHttps

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        var content = cell.defaultContentConfiguration()

        content.text = "Name: Name"
//        content.textProperties.font =
        content.secondaryText = "numder of comics: 432"
        content.secondaryTextProperties.color = .secondaryLabel
        if let imageUrl = URL(string: marvelImage.makeUrlForHttps),
           let  imageData = try? Data(contentsOf: imageUrl) {
            content.image = UIImage(data: imageData)
        } else {
            content.image = UIImage(named: "square-image")
        }
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content

return cell
    }


}

