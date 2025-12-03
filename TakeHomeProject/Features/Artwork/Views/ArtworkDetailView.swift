//
//  ArtworkCardView.swift
//  TakeHomeProject
//
//  Created by Andreas Margono on 25/11/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtworkDetailView: View {
    @State var artworks: Artwork?
    @ObservedObject var viewModel = ArtworkViewModel()
    @State private var isPresented = false
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var imageURL: String = ""
    @State private var isLoaded = false
    @State private var isError: Bool = false
    
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
                    WebImage(url: URL(string:artworks?.imageURL(iiifURL: viewModel.iiifURL) ?? "no image")){ image in
                        image.resizable().frame(width : 300, height: 300).scaledToFit()
                    } placeholder: {
                        WebImage(url : URL(string: "https://images.wondershare.com/repairit/article/fixing-the-image-not-available-error-01.png")).resizable( ).frame(width : 300, height: 300).scaledToFit()
                    }.onSuccess { _,_,_  in
                        isLoaded = true
                        imageURL = artworks?.imageURL(iiifURL: viewModel.iiifURL) ?? "no image"
                        showAlert = true
                        
                    }.onFailure() { _ in
                        isLoaded = false
                        imageURL = "https://images.wondershare.com/repairit/article/fixing-the-image-not-available-error-01.png"
                    }
                    
                    Button(action: {
                        Task {
                            isSaving = true
                            await viewModel.saveView(imageUrl:imageURL)
                            isSaving = false
                        }
                    }, label: {
                        if isSaving {
                            ProgressView()
                        } else {
                            Image(systemName: "arrow.down.to.line")
                                .foregroundStyle(Color.red)
                                .font(.system(size: 30, weight: .bold))
                        }
                    }).alert("Successfully Download Image", isPresented: $viewModel.showAlert) {
                        Button("OK", role: .cancel) { }
                    }.padding(.bottom, 20)
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
                                WebImage(url: URL(string:artworks?.imageURL(iiifURL: viewModel.iiifURL) ?? "no image")){ image in
                                    image.resizable().frame(width : 100, height: 100).scaledToFit()
                                } placeholder: {
                                    WebImage(url : URL(string: "https://images.wondershare.com/repairit/article/fixing-the-image-not-available-error-01.png")).resizable( ).frame(width : 100, height: 100).scaledToFit()
                                }
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
    @StateObject var viewModel = ArtworkViewModel()
    var body: some View {
        
        ZStack {
            VStack(alignment: .center){
                WebImage(url: URL(string:artworks?.imageURL(iiifURL: viewModel.iiifURL) ?? "no image")){ image in
                    image.resizable().frame(width : 300, height: 300).scaledToFit()
                } placeholder: {
                    WebImage(url : URL(string: "https://images.wondershare.com/repairit/article/fixing-the-image-not-available-error-01.png")).resizable().frame(width : 300, height: 300).scaledToFit()
                }
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
