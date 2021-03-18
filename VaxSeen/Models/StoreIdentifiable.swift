//
//  StoreIdentifiable.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/18/21.
//

import Foundation


protocol StoreIdentifiable: Identifiable {
    
    var hasAppointments: Bool { get }
    var city: String { get }
    var state: String { get }
    
    var titleDescription: String { get }
    var detailDescription: String { get }
}


protocol StoreLocatable {
    
    var locationType: LocationType { get }
    var description: String { get }
}

enum LocationType {
    case coordinates(latitude: Double, longitude: Double)
    case cityRegion(city: String, region: String)
}
