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

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct MapView: View {
    var coordinates: CLLocationCoordinate2D
    
    @State private var region = MKCoordinateRegion()
    @State private var markers = [Marker]()

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: markers) { marker in
            marker.location
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            print(coordinates.latitude)
            print(coordinates.longitude)
            region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            markers.append((Marker(location: MapMarker(coordinate: coordinates, tint: .red))))
        }
    }
}
