//
//  StoreMapView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/10/21.
//

import SwiftUI
import MapKit


struct StoreMapView: View {
    
    private let locationController = LocationController()
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:30, longitude: 40), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    let store: Store
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, showsUserLocation: true)
        }
        .navigationTitle("Locaation")
        .onAppear {
            locationController.geoCodeAddress("\(store.city), \(store.state)") { (placemark) in
                if let coordinate = placemark?.location?.coordinate {
                    region = MKCoordinateRegion(center: coordinate,
                                                span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
                }
            }
        }
    }
}

struct StoreMapView_Previews: PreviewProvider {
    static var previews: some View {
        StoreMapView(store: Store.testStore)
    }
}
