import UIKit

class TableViewCell: UITableViewCell {

    let urlConstructor = URLConstructor()

    private lazy var cellImageView: UIImageView = {
    let imageView = UIImageView()
       imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        return imageView
   }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")

        setupHierarchy()
    }

    func setupHierarchy() {
        contentView.addSubview(cellImageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            cellImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            cellImageView.heightAnchor.constraint(equalTo: cellImageView.widthAnchor, multiplier: 0.69)
        ])

    }

    func configureWith(_ comic: Comic) {
        if let imageUrlString = urlConstructor.getImageUrl(path: comic.thumbnail?.path,
                                                           size: .small,
                                                           extention: comic.thumbnail?.imageExtension) {
            cellImageView.loadImage(at: imageUrlString)
        } else {
            cellImageView.image = UIImage(systemName: "photo.artframe")
        }


//        var content = self.defaultContentConfiguration()
//        content.text = "\(comic.title)"
//
////        content.image = cellImageView.image
//        self.contentConfiguration = content

        self.accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
