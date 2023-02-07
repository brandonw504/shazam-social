//
//  MapView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/6/23.
//

import SwiftUI
import RealmSwift
import CoreLocation
import MapKit

/**
 Displays a map with markers where users Shazamed their songs.
 */
struct MapView: View {
    @StateObject var locationManager = LocationManager()
    @Binding var posts: [Post]
    @State var currentPost = Post()
    
    @State private var region = MKCoordinateRegion()
    @State private var showingSheet = false

    var body: some View {
        /*
         I believe the purple error (memory leak) "Publishing changes from within view updates is not allowed, this will cause undefined behavior." comes from here.
         It begins appearing when we move around on the map.
         This article addresses animating the map, and suggested that there we can't do much about this ourselves.
         https://www.donnywals.com/xcode-14-publishing-changes-from-within-view-updates-is-not-allowed-this-will-cause-undefined-behavior/
         My implementation seems to follow the typical way to use Map, so I decided to ignore the warning.
         */
        Map(coordinateRegion: $region, showsUserLocation: false, annotationItems: posts) { post in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: post.latitude!, longitude: post.longitude!)) {
                Image(systemName: "mappin")
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        // Ensure that the tapped post is assigned before showing the sheet.
                        DispatchQueue.main.async {
                            currentPost = post
                        }
                        showingSheet = true
                    }
            }
        }
        .edgesIgnoringSafeArea(.all)
        // Open a detail view for the song at the marker you tapped on.
        .sheet(isPresented: $showingSheet) {
            MapPostView(post: $currentPost)
                // Custom presentation detent allows the parent view (the map) to still be interacted with.
                .presentationDetents(undimmed: [.medium])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            locationManager.requestLocation()
            // Set the initally shown region to the user's location, but if no location is found, default to Davis, CA.
            region = MKCoordinateRegion(center: locationManager.location ?? CLLocationCoordinate2D(latitude: 38.56043542143025, longitude: -121.76042214745614), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
    }
}
