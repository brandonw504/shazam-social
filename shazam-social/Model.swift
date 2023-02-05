//
//  Model.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import Foundation
import RealmSwift
import CoreLocation

final class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var posts = RealmSwift.List<Post>()
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

final class Post: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var id: ObjectId
    @Persisted var name: String
    @Persisted var title: String
    @Persisted var artist: String
    @Persisted var albumArtURL: String
    @Persisted var songID: String
    @Persisted var caption: String
    @Persisted var createdAt: Date?
    @Persisted var location: String?
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    
    convenience init(name: String, title: String, artist: String, albumArtURL: String, songID: String, caption: String, location: String?, latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) {
        self.init()
        self.name = name
        self.title = title
        self.artist = artist
        self.albumArtURL = albumArtURL
        self.songID = songID
        self.caption = caption
        self.createdAt = Date()
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
    }
}
