//
//  ArtworkResponse.swift
//  TakeHomeProject
//
//  Created by Andreas Margono on 25/11/25.
//

import Foundation

struct ArtworkResponse: Codable {
    let pagination: Pagination
    let data: [Artwork]
    let config: APIConfig
}

struct Pagination: Codable {
    let total : Int
    let limit : Int
    let offset: Int
    let total_pages: Int
    let current_page: Int
    let next_url: String?
    let prev_url: String?
    
}
