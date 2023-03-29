import Foundation
import Alamofire 

final class NetworkManager {

    static let shared = NetworkManager()
    
    func fetchSeries(from url: String, complition: @escaping (Result<[Comic], AFError>) -> Void) {

        AF.request(url).responseDecodable(of: DataMarvel.self) { data in
                guard let dataValue = data.value else {
                    if let error = data.error {
                    complition(.failure(error))
                    }
                    return }

                let comics = dataValue.data.results
                complition(.success(comics))
        }
    }

    func loadImage(from urlString: String, complition: @escaping (Result<Data?, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error {
                complition(.failure(error))
            }
            complition(.success(data))
        }
        task.resume()
    }
}
