import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

    // MARK: - Configuration

    func configureWith(_ comic: Comic, image: UIImage?) {
        portraitImageView.image = image
        nameLabel.text = comic.title
        detailLabel.text = comic.description
    }
}
