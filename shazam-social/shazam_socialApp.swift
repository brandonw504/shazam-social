//
//  shazam_socialApp.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import SwiftUI
import RealmSwift

let app: RealmSwift.App? = RealmSwift.App(id: realmKey) // TODO: key in

@main
struct shazam_socialApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            // Using Sync?
            if let app = app {
                SyncContentView(app: app)
            }
        }
    }
}
