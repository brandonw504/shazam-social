//
//  PostCard.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/3/23.
//

import SwiftUI

struct PostCard: View {
    var post: Post
    
    var timeSincePost: String {
        let now = Date()
        let time = now.offset(from: post.createdAt ?? Date())
        return time == "" ? "Just now" : time
    }
    
    var body: some View {
        Section {
            ZStack {
                VStack {
                    HStack {
                        Text(timeSincePost).padding(3).font(.system(size: 12)).foregroundColor(.gray)
                        Spacer()
                        Text(post.location ?? "").padding(3).font(.system(size: 12)).foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text(post.title).font(.title).padding(3)
                        Spacer()
                        Text(post.artist).font(.headline).padding(3).foregroundColor(.gray)
                    }
                    
                    AsyncImage(url: URL(string: post.albumArtURL)) { image in
                        image.resizable().aspectRatio(contentMode: .fit).cornerRadius(15).padding(5)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    HStack {
                        Text(post.name).font(.headline).padding(3)
                        Spacer()
                    }
                    
                    HStack {
                        Text(post.caption).font(.caption).padding(3)
                        Spacer()
                    }
                }
            }
        }
    }
}
