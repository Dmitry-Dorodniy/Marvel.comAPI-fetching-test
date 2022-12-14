import Foundation
import Alamofire 

class NetworkManager {

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
}
