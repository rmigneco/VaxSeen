//
//  StoreMapView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/10/21.
//

import SwiftUI
import MapKit


struct StoreMapView: View {
    @Environment(\.presentationMode) var presentationMode
    
    private let locationController = LocationController()
    
    @State private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:30, longitude: 40), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    let store: StoreLocatable
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $coordinateRegion, showsUserLocation: true)
                .navigationTitle("\(store.description)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                         Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                         }
                     }
                 }
        }
        .onAppear {
            switch store.locationType  {
            case .cityRegion(let city, let region):
                locationController.geoCodeAddress("\(city), \(region)") { (placemark) in
                    DispatchQueue.main.async {
                        if let coordinate = placemark?.location?.coordinate {
                            coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                                  span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
                        }
                    }
                }
            case .coordinates(let latitude, let longitude):
                coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                                      span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
            }
        }
    }
}

struct StoreMapView_Previews: PreviewProvider {
    static var previews: some View {
        StoreMapView(store: CVSStoreLocation.testStore)
    }
}
