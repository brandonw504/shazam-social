//
//  ShazamView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI
import RealmSwift

struct ShazamView: View {
    @ObservedRealmObject var user: User
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var shazamHelper = ShazamHelper()
    
    @State private var showingNewPost = false
    @State private var popView = false
    @State private var scale = false
    
    let background = "https://media.istockphoto.com/id/1353553203/photo/forest-wooden-table-background-summer-sunny-meadow-with-green-grass-forest-trees-background.jpg?b=1&s=170667a&w=0&k=20&c=-jvR1WDwcloLXRgRTGeyG3frvrhPIbegdemeL6vY2Pk="
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: background)) { image in
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
                        .scaleEffect(scale ? 0.95 : 1.05)
                        .task {
                            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                                scale.toggle()
                            }
                        }
                } placeholder: {
                    ProgressView()
                }
                Spacer()
                Button(action: { shazamHelper.startOrEndListening() }) {
                    Text(shazamHelper.isRecording ? "Listening..." : "Start Shazaming")
                        .frame(width: 300)
                }.buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .shadow(radius: 4)
                Spacer()
            }
        }
        .navigationDestination(isPresented: $shazamHelper.foundSong) {
            let helper = shazamHelper.shazamMedia
            NewPostView(user: user, popView: $popView, title: helper.title, artist: helper.artist, albumArtURL: helper.albumArtURL, songID: helper.songID)
        }
        .onAppear() {
            if (popView) {
                presentationMode.wrappedValue.dismiss()
                popView = false
            }
        }
    }
}
