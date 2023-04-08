import UIKit

final class TableViewCell: UITableViewCell {

    let urlConstructor = URLConstructor()

    private lazy var cellImageView: UIImageView = {
    let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
   }()

    private lazy var titleLabel: UILabel = {
        let tittle = UILabel()
        tittle.numberOfLines = 0
        return tittle
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")

        self.accessoryType = .disclosureIndicator
        setupHierarchy()
    }

    private func setupHierarchy() {
        contentView.addSubviewsForAutoLayout([cellImageView,
                                              titleLabel])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            cellImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            cellImageView.heightAnchor.constraint(equalTo: cellImageView.widthAnchor, multiplier: 0.69)
        ])

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configureWith(_ comic: Comic) {
        if let imageUrlString = urlConstructor.getImageUrl(path: comic.thumbnail?.path,
                                                           size: .small,
                                                           extention: comic.thumbnail?.imageExtension) {
//            cellImageView.loadImageWithCash(at: imageUrlString)
            NetworkManager.shared.loadImage(from: imageUrlString) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.cellImageView.image = image
                        }
                    }
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            }
        } else {
            cellImageView.image = UIImage(systemName: "photo.artframe")
        }
        titleLabel.text = "\(comic.title)"
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

