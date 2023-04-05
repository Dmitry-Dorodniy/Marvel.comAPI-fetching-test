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
            
   //       portraitImageView.loadImageWithCash(at: imageUrlString)
            NetworkManager.shared.loadImage(from: imageUrlString) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.portraitImageView.image = image
                        }
                    }
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
            }
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

    func configureWithAsyncLoad(_ comic: Comic) async {
        if let imageUrlString = urlConstructor.getImageUrl(path: comic.thumbnail?.path,
                                                           size: .portrait,
                                                           extention: comic.thumbnail?.imageExtension) {
            do {
                let data = try await NetworkManagerAsync.shared.loadImageAsync(from: imageUrlString)
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.portraitImageView.image = image
                    }
                }
            } catch {
                    print("invalid data")
            }
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
