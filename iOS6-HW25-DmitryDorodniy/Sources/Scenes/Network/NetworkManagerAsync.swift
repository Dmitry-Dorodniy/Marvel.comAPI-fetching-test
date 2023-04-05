//
//  NetworkManagerAsync.swift
//  iOS6-HW25-DmitryDorodniy
//
//  Created by Dmitry Dorodniy on 05.04.2023.
//

import Foundation

final class NetworkManagerAsync {

    static let shared = NetworkManagerAsync()
    private init() { }

    func loadImageAsync(from urlString: String) async throws -> Data? {
        guard let url = URL(string: urlString) else { throw NetworkError.badUrl }
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        let responce = try await URLSession.shared.data(for: urlRequest)
        return responce.0
    }
}

enum NetworkError: Error {
    case badUrl, badRequest, badResponce, invalidData
}
