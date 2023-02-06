//
//  ProfilePostView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/6/23.
//

import SwiftUI
import MediaPlayer

/**
 `Detail view for a Shazamed song.`
 */
struct ProfilePostView: View {
    var post: Post
    
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
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
            Text(post.artist).font(.headline).padding(3).foregroundColor(.gray)
            
            Divider()
            
            CachedAsyncImage(url: post.albumArtURL).onTapGesture {
                handleSong(id: post.songID)
            }
            
            Text(post.name).font(.headline).padding(3)
            Text(post.caption).font(.caption).padding(3)
            
            HStack {
                Text(timeSincePost).padding(3).font(.system(size: 12)).foregroundColor(.gray)
                Spacer()
                Text(post.location ?? "").padding(3).font(.system(size: 12)).foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle(post.title)
        .onDisappear {
            stopSong()
        }
    }
}
