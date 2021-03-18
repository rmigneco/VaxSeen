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
