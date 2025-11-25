//
//  ArtworkCardView.swift
//  TakeHomeProject
//
//  Created by Andreas Margono on 25/11/25.
//

import SwiftUI

struct ArtworkDetailView: View {
    @State var artworks: Artwork?
    @StateObject var viewModel = ArtworkViewModel()
    @State private var isPresented = false
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.displayScale) var displayScale

    var filteredArtworks: [Artwork] {
        guard let artistName = artworks?.artist_display else { return [] }
        return viewModel.listArtworks.filter { artwork in
            artwork.artist_display == artistName && artwork.id !=
            artworks?.id
        }
    }

    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                VStack(alignment: .center){
                    AsyncImage(url: URL(string: artworks?.ImageUrl ?? "no Image")).frame(maxWidth: .infinity).scaledToFit()
                    Button(action: {
                        Task {
                            await saveView(imageUrl: artworks?.ImageUrl ?? "")
                        }
                    }, label: {
                        if isSaving {
                            ProgressView()
                        } else {
                            Image(systemName: "arrow.down.to.line")
                                .foregroundStyle(Color.red)
                                .font(.system(size: 30, weight: .bold))
                        }
                    }).padding(.bottom, 20)
                    Button("Show Image Full Screen") {
                        isPresented.toggle()
                    }
                }
                .fullScreenCover(isPresented: $isPresented, content: FullScreenModalView.init)
                .padding(.bottom, 20)
                
                VStack(alignment: .leading){
                    Text("Artwork Detail").font(.title2)
                    Text("Year : \(artworks?.date_end ?? 0)").font(.subheadline)
                    Text(artworks?.artist_display ?? "no artist").padding(.bottom,20)
                    
                    Text(artworks?.description ?? "No description in the API")
                    
                    Spacer().frame(height: 80)
                    Text("Other Artwork by \(artworks?.artist_display ?? "this artist")").padding(.bottom,20).font(.headline)
                    
                    if filteredArtworks.isEmpty {
                        Text("No Other Artwork")
                    }else{
                        List(filteredArtworks){ artistArtworks in
                            HStack{
                                AsyncImage(url: URL(string: artistArtworks.ImageUrl ?? "no Image")).frame(width: 100, height: 100).scaledToFit()
                                VStack(alignment: .leading) {
                                    Text(artistArtworks.title)
                                    Text("\(artistArtworks.date_end)")
                                }
                                
                            }
                        }
                    }
                }
                
                
                
            }.padding(20)
                .navigationTitle(artworks?.title ?? "no title")
        }
    }
    
    @MainActor func saveView(imageUrl : String) async {
        do {
            guard let url = URL(string: imageUrl) else {
                alertMessage = "Invalid image URL"
                showAlert = true
                return
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let uiImage = UIImage(data: data) else {
                alertMessage = "Failed to load image"
                showAlert = true
                isSaving = false
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            alertMessage = "Image saved successfully!"
            showAlert = true
            
        } catch {
            alertMessage = "Failed to save: \(error.localizedDescription)"
            showAlert = true
        }

        
        
    }
}

fileprivate struct CardView: View {
    let imageName: String
    
    var body: some View {
        
        VStack(spacing: 30) {
            Text(imageName)
            Image(systemName: imageName)
        }
        .foregroundStyle(Color.red)
        .font(.system(size: 20, weight: .bold))
        .padding(.vertical, 50)
        .padding(.horizontal, 30)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.red.opacity(0.1))
                .stroke(Color.red, style: StrokeStyle(lineWidth: 3))
        )
        
    }
}

struct FullScreenModalView: View {
    @Environment(\.dismiss) var dismiss
    @State var artworks: Artwork?
    var body: some View {
        
        ZStack {
            VStack(alignment: .center){
                AsyncImage(url: URL(string: artworks?.ImageUrl ?? "no Image")).frame(maxWidth: .infinity).scaledToFit()
                Button("Dismiss Modal") {
                    dismiss()
                }
            }
            
        }
    }
}

#Preview {
    ArtworkDetailView()
}
