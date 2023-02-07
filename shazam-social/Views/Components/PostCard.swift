//
//  PostCard.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/3/23.
//

import SwiftUI

/**
 Displays a post tile for the feed page.
 */
struct PostCard: View {
    var post: Post
    
    // Provides a custom description for how long ago a post was created.
    var timeSincePost: String {
        let now = Date()
        let time = now.offset(from: post.createdAt ?? Date())
        return time == "" ? "Just now" : time
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
                
                // Custom AsyncImage that's cached. Prevents reloading when it scrolls off-screen.
                CachedAsyncImage(url: post.albumArtURL)
                
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
    }
}
