import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Properties
    private let urlConstructor = URLConstructor()
    @IBOutlet weak var portraitImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var detailLabel: UITextView!
    
    // MARK: - Configuration

    func configureWith(_ comic: Comic) {
        portraitImageView.image?.withTintColor(.lightGray)
        portraitImageView.image = UIImage(systemName: "person.crop.artframe")?.withTintColor(.lightGray)
       if let imageUrlString = urlConstructor.getImageUrl(path: comic.thumbnail?.path,
                                                        size: .portrait,
                                                          extention: comic.thumbnail?.imageExtension) {
        portraitImageView.loadImage(at: imageUrlString)
       } else {
           portraitImageView.image = UIImage(systemName: "photo.artframe")
       }
        nameLabel.text = comic.title
        detailLabel.text = comic.description
    }
}
