//
//  Artwork.swift
//  TakeHomeProject
//
//  Created by Andreas Margono on 25/11/25.
//

import Foundation

struct APIData: Codable {
    let data : [Artwork]
    let config : APIConfig
}

struct APIConfig : Codable {
    let iiif_url : String
}

struct Artwork: Codable, Identifiable {
    let id: Int
    let title: String
    let date_end: Int?
    let date_display: String?
    let artist_display: String?
    let description: String?
    let image_id : String?
    
    func imageURL(iiifURL: String) -> String? {
        guard let imageId = image_id, !iiifURL.isEmpty else { return "" }
        print("\(iiifURL)/\(imageId)/full/400,/0/default.jpg")
        return "\(iiifURL)/\(imageId)/full/400,/0/default.jpg"
    }

}
