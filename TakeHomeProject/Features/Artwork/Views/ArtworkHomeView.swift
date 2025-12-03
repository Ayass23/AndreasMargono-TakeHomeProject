//
//  ArtworkHomeView.swift
//  TakeHomeProject
//
//  Created by Andreas Margono on 25/11/25.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct ArtworkHomeView: View {
    
    @ObservedObject var viewModel = ArtworkViewModel()
    @State private var searchArtwork = ""
    @State private var isFiltered = false
    @State private var isFilteredAscending = false
    @State private var isFilteredDecending = false
    
    var SearchedArtworks: [Artwork] {
        let filtered = viewModel.listArtworks
            if !searchArtwork.isEmpty {
                return filtered.filter{ artwork in
                    artwork.title.contains(searchArtwork)
                }
            }
            if isFilteredAscending{
                return filtered.sorted(by: { ($0.date_end ?? 0) < ($1.date_end ?? 0) })
            }
            if isFilteredDecending{
                return filtered.sorted(by: { ($0.date_end ?? 0) > ($1.date_end ?? 0) })
            }
        return filtered
        }
    
    var body: some View {
        NavigationStack {
            List (SearchedArtworks){ artwork in
                NavigationLink {
                    ArtworkDetailView(artworks: artwork)
                } label: {
                    HStack{
                        WebImage(url: URL(string:artwork.imageURL(iiifURL: viewModel.iiifURL) ?? "no image")){ image in
                            image.resizable().frame(width : 100, height: 100).scaledToFit()
                        } placeholder: {
                            WebImage(url : URL(string: "https://images.wondershare.com/repairit/article/fixing-the-image-not-available-error-01.png")).resizable( ).frame(width : 100, height: 100).scaledToFit()
                        }

                        VStack(alignment: .leading) {
                            Text(artwork.title)
                            Text("\(artwork.date_end ?? 0)")
                        }

                    }
                    
                    
                }

            }.navigationTitle("Artworks")
                .searchable(text: $searchArtwork, prompt: "Search your Artwork...")
                .toolbar {
                    ToolbarItem {
                        Menu("More", systemImage: "ellipsis") {
                            Button {
                                isFilteredAscending = true
                                isFilteredDecending = false
                            } label: {
                                Label(
                                    "Filter Ascending",
                                    systemImage: isFilteredAscending ? "checkmark.circle.fill" : "circle"
                                )
                            }
                            Button {
                                isFilteredDecending = true
                                isFilteredAscending = false
                            } label: {
                                Label(
                                    "Filter Descending",
                                    systemImage: isFilteredDecending ? "checkmark.circle.fill" : "circle"
                                )
                            }
                            Button {
                                isFilteredDecending = false
                                isFilteredAscending = false
                            } label: {
                                Label(
                                    "Clear Filter",
                                    systemImage: (!isFilteredDecending && !isFilteredAscending) ? "checkmark.circle.fill" : "circle"
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
