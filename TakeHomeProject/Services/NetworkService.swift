//
//  NetworkService.swift
//  TakeHomeProject
//
//  Created by Andreas Margono on 25/11/25.
//

import Foundation

class NetworkService {
    func fetchArtworks(page: Int = 2, limit: Int = 100) async throws -> ArtworkResponse  {
        let urlString = "https://api.artic.edu/api/v1/artworks?page=\(page)&limit=\(limit)&fields=id,title,artist_display,date_display,date_end,image_id,description,config"
        guard let url = URL(string: urlString) else{
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"  // optional
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        let responses = try decoder.decode(ArtworkResponse.self, from: data)
print(responses)
        return responses
    }
}
