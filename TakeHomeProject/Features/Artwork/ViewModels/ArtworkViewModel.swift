//
//  ArtworkViewModel.swift
//  TakeHomeProject
//
//  Created by Andreas Margono on 25/11/25.
//

import Foundation
import Combine
import SDWebImageSwiftUI

@MainActor
class ArtworkViewModel: ObservableObject {

    @Published var listArtworks: [Artwork] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var iiifURL: String = ""
    @Published var showAlert = false
    @Published var isSaving = false


    private let networkService = NetworkService()
    private var currentPage: Int = 1

    func fetchArtwork() async {
        isLoading = true
        errorMessage = nil

        do{
            let responses = try await networkService.fetchArtworks()
            listArtworks = responses.data
            iiifURL = responses.config.iiif_url
            
            currentPage += 1
        }catch {
            errorMessage = "Failed to load artworks: \(error.localizedDescription)"
            print("Error fetching artworks: \(error)")
        }
        isLoading = false
    }
    
    
    func saveView(imageUrl : String) async {
        do {
            guard let url = URL(string: imageUrl) else {
                self.showAlert = true
                return
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let uiImage = UIImage(data: data) else {
                self.showAlert = true
                self.isSaving = false
                return
            }
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            self.showAlert = true
            self.isSaving = true
        } catch {
            self.showAlert = true
        }
    }
    
}
