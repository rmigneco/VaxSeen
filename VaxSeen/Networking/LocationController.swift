//
//  LocationController.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/10/21.
//

import Foundation
import CoreLocation


final class LocationController {
    
    private let geocoder = CLGeocoder()
    
    init() {}
    
    func geoCodeAddress(_ address: String, completion: @escaping (CLPlacemark?) -> Void) {
        geocoder.geocodeAddressString(address, in: nil, preferredLocale: Locale.autoupdatingCurrent) { (placeMarks, error) in
            completion(placeMarks?.first)
        }
    }
    
    
}
