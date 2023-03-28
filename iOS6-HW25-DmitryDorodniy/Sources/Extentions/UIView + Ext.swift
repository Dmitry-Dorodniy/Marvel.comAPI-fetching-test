import UIKit

var imageCahce = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImage(at urlString: String) {

        if let image = imageCahce.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCahce.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }

    func loadImageWithCash(at urlString: String) {

        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
            task.resume()
        }
    }
}

extension UIView {

    func addSubviewsForAutoLayout(_ views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
    }
}

extension UIView {
    func shadow(opacity: Float, offset: CGSize, radius: CGFloat) {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
}
