//
//  ArtworkHomeView.swift
//  TakeHomeProject
//
//  Created by Andreas Margono on 25/11/25.
//

import SwiftUI

struct ArtworkHomeView: View {
    
    @StateObject var viewModel = ArtworkViewModel()
    @State private var searchArtwork = ""
    @State private var isFiltered = false
    
    var SearchedArtworks: [Artwork] {
        var filtered = viewModel.listArtworks
        if !searchArtwork.isEmpty {
            return filtered.filter{ artwork in
                artwork.title.contains(searchArtwork)
            }
        }
                if isFiltered{
                    return filtered.sorted(by: { ($0.date_end) < ($1.date_end) })
                }
        return filtered
        }
    
    var filteredArtworks: [Artwork] {
        if isFiltered == false {
            return viewModel.listArtworks
        } else {
            return viewModel.listArtworks.sorted(by: { ($0.date_end ?? 0) < ($1.date_end ?? 0) })
        }
    }
    
    var body: some View {
        NavigationStack {
            List (SearchedArtworks){ artwork in
                NavigationLink {
                    ArtworkDetailView(artworks: artwork)
                } label: {
                    HStack{
                        AsyncImage(url: URL(string: artwork.ImageUrl ?? "no Image")).frame(width: 100, height: 100).scaledToFit()
                        VStack(alignment: .leading) {
                            Text(artwork.title)
                            Text("\(artwork.date_end)")
                        }

                    }
                    
                    
                }

            }.navigationTitle("Artworks")
                .searchable(text: $searchArtwork, prompt: "Search your Artwork...")
                .toolbar {
                    ToolbarItem {
                        Menu("More", systemImage: "ellipsis") {
                            Button {
                                isFiltered.toggle()
                            } label: {
                                Label(
                                    isFiltered ? "Filter by Year: ON" : "Filter by Year: OFF",
                                    systemImage: isFiltered ? "checkmark.circle.fill" : "circle"
                                )
                            }
                        }
                    }
                }
                .task {
                    await viewModel.fetchArtwork()
                }
        }
    }
}

#Preview {
    ArtworkHomeView()
}
