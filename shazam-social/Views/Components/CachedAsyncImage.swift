//
//  CachedAsyncImage.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/6/23.
//

import SwiftUI

/**
 `Custom AsyncImage that's cached. Prevents reloading on scroll.`
 */
struct CachedAsyncImage: View {
    @StateObject var imageLoader: ImageLoader
    
    init(url: String?) {
        self._imageLoader = StateObject(wrappedValue: ImageLoader(url: url))
    }
    
    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).cornerRadius(10).padding(5)
            } else if let error = imageLoader.errorMessage {
                Text(error).foregroundColor(.pink)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            imageLoader.fetch()
        }
    }
}
