//
//  LocalSearchService.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/3/23.
//

import Foundation
import Combine
import MapKit

/**
 `Performs an MKLocalSearch to find points of interest around the user's current location.`
 */
final class LocalSearchService {
    let localSearchPublisher = PassthroughSubject<[MKMapItem], Never>()
    private let radius: CLLocationDistance

    init(radius: CLLocationDistance = 5000) {
        self.radius = radius
    }
    
    public func search(searchText: String, center: CLLocationCoordinate2D) {
        request(searchText: searchText, center: center)
    }
    
    private func request(searchText: String, center: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.pointOfInterestFilter = .includingAll
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(center: center, latitudinalMeters: radius, longitudinalMeters: radius)
        let search = MKLocalSearch(request: request)

        // Pass the search results back up to the viewData in LocalSearchData.
        search.start { [weak self](response, _) in
            guard let response = response else {
                return
            }

            self?.localSearchPublisher.send(response.mapItems)
        }
    }
}
