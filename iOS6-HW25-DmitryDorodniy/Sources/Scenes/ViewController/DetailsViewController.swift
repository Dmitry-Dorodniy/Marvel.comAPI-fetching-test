import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Properties
    private let urlConstructor = URLConstructor()
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    
    // MARK: - Configuration

    func configureWith(_ comic: Comic) {
        setupDefaultView()
        if let imageUrlString = urlConstructor.getImageUrl(path: comic.thumbnail?.path,
                                                           size: .portrait,
                                                           extention: comic.thumbnail?.imageExtension) {
            portraitImageView.loadImage(at: imageUrlString)
        } else {
            setupDefaultView()
        }
        nameLabel.text = comic.title

        if let description = comic.description {
            detailLabel.text = description
        } else {
            detailLabel.textColor = .secondaryLabel
            detailLabel.textAlignment = .center
            detailLabel.text = "There no description here..."
        }
    }

    func setupDefaultView() {
        portraitImageView.tintColor = .systemGray5
        portraitImageView.image = UIImage(systemName: "icloud.and.arrow.down")
        portraitImageView.shadow(opacity: 0.5, offset: CGSize(width: 5, height: 5), radius: 5)
    }
}
