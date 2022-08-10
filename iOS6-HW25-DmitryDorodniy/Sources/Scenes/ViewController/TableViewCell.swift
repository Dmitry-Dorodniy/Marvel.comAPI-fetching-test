import UIKit

class TableViewCell: UITableViewCell {

    let urlConstructor = URLConstructor()
    var cellImageView = UIImageView(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "cell")
    }

//    func configureWith(_ comic: Comic, image: UIImage?) {
//        var content = self.defaultContentConfiguration()
//        content.text = "\(comic.title)"
//        content.image = image
//        self.accessoryType = .disclosureIndicator
//        self.contentConfiguration = content
//    }

    func configureWith(_ comic: Comic) {
        if let imageUrlString = urlConstructor.getImageUrl(path: comic.thumbnail?.path,
                                                           size: .small,
                                                           extention: comic.thumbnail?.imageExtension) {
            cellImageView.loadImage(at: imageUrlString)
        } else {
            cellImageView.image = UIImage(systemName: "photo.artframe")
        }

        var content = self.defaultContentConfiguration()
        content.text = "\(comic.title)"

        content.image = cellImageView.image

        self.accessoryType = .disclosureIndicator
        self.contentConfiguration = content
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
