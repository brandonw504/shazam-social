//
//  ShazamView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI

struct ShazamView: View {
    @StateObject private var viewModel = ContentViewModel()
    @Binding var name: String
    
    @State private var showingNewPost = false
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: "https://media.istockphoto.com/id/1353553203/photo/forest-wooden-table-background-summer-sunny-meadow-with-green-grass-forest-trees-background.jpg?b=1&s=170667a&w=0&k=20&c=-jvR1WDwcloLXRgRTGeyG3frvrhPIbegdemeL6vY2Pk=")) { image in
                    image
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 10, opaque: true)
                    .opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
            } placeholder: {
                EmptyView()
            }
            VStack(alignment: .center) {
                Spacer()
                AsyncImage(url: URL(string: "https://assets.stickpng.com/images/580b57fcd9996e24bc43c538.png")) { image in
                        image
                        .resizable()
                        .frame(width: 300, height: 300)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                Spacer()
                Button(action: { viewModel.startOrEndListening() }) {
                    Text(viewModel.isRecording ? "Listening..." : "Start Shazaming")
                        .frame(width: 300)
                }.buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .shadow(radius: 4)
                Spacer()
            }
        }
        .navigationDestination(isPresented: $viewModel.foundSong) {
            NewPostView(name: $name, title: viewModel.shazamMedia.title, artist: viewModel.shazamMedia.artist, albumArtURL: viewModel.shazamMedia.albumArtURL)
        }
    }
}
