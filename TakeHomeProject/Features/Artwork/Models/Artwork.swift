//
//  Artwork.swift
//  TakeHomeProject
//
//  Created by Andreas Margono on 25/11/25.
//

import Foundation

struct APIData: Codable {
    let data : Artwork
    let config : APIConfig
}

struct APIConfig : Codable {
    let iiif_url : String
}

struct Artwork: Codable, Identifiable {
    let id: Int
    let title: String
    let date_end: Int
    let date_display: String?
    let artist_display: String?
    let description: String?
    let image_id : String?
    
    var ImageUrl : String? {
        guard let imageId = image_id else { return nil }
//        print(imageId)
        let urlString = "https://www.artic.edu/iiif/2/\(imageId)/full/843,/0/default.jpg"
//        print("Generated URL:", urlString)
        return urlString
    }

}
