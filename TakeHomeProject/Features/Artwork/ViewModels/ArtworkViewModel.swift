//
//  ArtworkViewModel.swift
//  TakeHomeProject
//
//  Created by Andreas Margono on 25/11/25.
//

import Foundation
import Combine

@MainActor
class ArtworkViewModel: ObservableObject {
    
    @Published var listArtworks: [Artwork] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    
    
    private let networkService = NetworkService()
    private var currentPage: Int = 1
    
    
    
    func fetchArtwork() async {
        isLoading = true
        errorMessage = nil

        do{
            let responses = try await networkService.fetchArtworks()
            listArtworks = responses.data
            currentPage += 1
        }catch {
            errorMessage = "Failed to load artworks: \(error.localizedDescription)"
            print("Error fetching artworks: \(error)")
        }
        isLoading = false
    }



//    func loadMoreArtwork() async {
//        isLoading = true
//
//        do{
//            let responses = try await networkService.fetchArtworks(page: currentPage, limit: 20)
//            listArtworks.append(contentsOf: responses.data)
//            currentPage += 1
//        }catch {
//            errorMessage = "Load more artworks failed: \(error.localizedDescription)"
//            print("Error loading more artworks: \(error)")
//        }
//
//        isLoading = false
//
//    }
    
    
}
