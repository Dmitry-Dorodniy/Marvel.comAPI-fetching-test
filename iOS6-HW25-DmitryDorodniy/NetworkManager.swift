//
//  NetworkManager.swift
//  iOS6-HW25-DmitryDorodniy
//
//  Created by Dmitry Dorodniy on 06.08.2022.
//

import Foundation
import Alamofire

class NetworkManager {

    func fetchSeries(from url: String, complition: @escaping (Result<[Comic], Error>) -> Void) {

        AF.request(url).responseDecodable(of: DataMarvel.self) { data in

            DispatchQueue.main.async {
                guard let dataValue = data.value else {
                    complition(.failure(AFError.self as! Error))
                    print("no data")
                    return }

                let comics = dataValue.data.results
                complition(.success(comics))
//                self.comics = comics
//                self.tableView.reloadData()
            }
        }
    }
}
