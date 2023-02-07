//
//  MapPostView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/6/23.
//

import SwiftUI
import MediaPlayer

/**
 Detail view for a Shazamed song.
 */
struct MapPostView: View {
    @Binding var post: Post
    @State private var playing = false
    
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    // Provides a custom description for how long ago a post was created.
    var timeSincePost: String {
        let now = Date()
        let time = now.offset(from: post.createdAt ?? Date())
        return time == "" ? "Just now" : time
    }
    
    // MARK: - Music Player
    func playSong(id: String) {
        musicPlayer.setQueue(with: [id])
        musicPlayer.prepareToPlay()
        musicPlayer.play()
    }
    
    func stopSong() {
        switch musicPlayer.playbackState {
        case .playing:
            musicPlayer.stop()
        default:
            return
        }
    }
    
    // Play the tapped song. If it's already playing, pause it.
    func handleSong(id: String) {
        switch musicPlayer.playbackState {
        case .playing:
            if (musicPlayer.nowPlayingItem?.playbackStoreID == id) {
                musicPlayer.pause()
            } else {
                musicPlayer.stop()
                playSong(id: id)
            }
        default:
            if (musicPlayer.nowPlayingItem?.playbackStoreID == id) {
                musicPlayer.play()
            } else {
                playSong(id: id)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.title)
                .font(.headline)
                .padding(3)
            Text(post.artist)
                .font(.subheadline)
                .padding(3)
                .foregroundColor(.gray)
            
            Divider()
            
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: post.albumArtURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding(5)
                } placeholder: {
                    ProgressView()
                }

                if (playing) {
                    Image(systemName: "pause.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(15)
                        .frame(width: 75, height: 75)
                } else {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(15)
                        .frame(width: 75, height: 75)
                }
            }
            .onTapGesture {
                playing.toggle()
                handleSong(id: post.songID)
            }
            
            Text(post.name)
                .font(.headline)
                .padding(3)
            Text(post.caption)
                .font(.caption)
                .padding(3)
            
            HStack {
                Text(timeSincePost)
                    .padding(3)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
                Text(post.location ?? "")
                    .padding(3)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .onDisappear {
            stopSong()
        }
    }
}
