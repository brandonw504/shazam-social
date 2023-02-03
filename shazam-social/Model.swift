//
//  Model.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import Foundation
import RealmSwift

final class Post: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var title: String
    @Persisted var artist: String
    @Persisted var albumArtURL: String
    @Persisted var caption: String
    @Persisted var createdAt: Date?
    
    convenience init(name: String, title: String, artist: String, albumArtURL: String, caption: String) {
        self.init()
        self.name = name
        self.title = title
        self.artist = artist
        self.albumArtURL = albumArtURL
        self.caption = caption
        self.createdAt = Date()
    }
}
