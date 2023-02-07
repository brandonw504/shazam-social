//
//  PostCard.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/3/23.
//

import SwiftUI
import MediaPlayer

/**
 Displays a post tile for the feed page.
 */
struct PostCard: View {
    var post: Post
    
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    @State private var playing = false
    
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
    // If it's a different song, stop the current one and play the new one.
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
        Section {
            VStack {
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
                
                Divider()
                
                HStack {
                    Text(post.title)
                        .font(.title)
                        .padding(3)
                    Spacer()
                    Text(post.artist)
                        .font(.headline)
                        .padding(3)
                        .foregroundColor(.gray)
                }
                
                ZStack(alignment: .bottomLeading) {
                    // Custom AsyncImage that's cached. Prevents reloading when it scrolls off-screen.
                    CachedAsyncImage(url: post.albumArtURL)

                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(15)
                        .frame(width: 75, height: 75)
                        .onTapGesture {
                            handleSong(id: post.songID)
                        }
                }
                
                HStack {
                    Text(post.name)
                        .font(.headline)
                        .padding(3)
                    Spacer()
                }
                
                HStack {
                    Text(post.caption)
                        .font(.caption)
                        .padding(3)
                    Spacer()
                }
            }
        }
        .onDisappear {
            stopSong()
        }
    }
}
