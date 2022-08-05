//
//  Characters.swift
//  iOS6-HW25-DmitryDorodniy
//
//  Created by Dmitry Dorodniy on 04.08.2022.
//

import Foundation

struct Characters: Decodable {
    let results: [Character]
}

struct Character: Decodable {
    let name: String
    let descriptions: String
    let thumbnail: ImagePath
    let comics: Available

    struct ImagePath: Decodable {
        let path: String
        let extention: String
    }

    struct Available: Decodable {
        let available: Int
    }
}
