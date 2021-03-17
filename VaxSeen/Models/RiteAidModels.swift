//
//  RiteAidModels.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/17/21.
//

import Foundation


struct RiteAidLocationResponse: Decodable {
    
    enum Keys: String, CodingKey {
        case locations
    }
    
    enum NestedKey: String, CodingKey {
        case loc
    }
    
    let locations: [RiteAidStoreLocation]
    
    
    init(from decoder: Decoder) throws {
        let topContainer = try decoder.container(keyedBy: Keys.self)
        var nestedUnkeyedContainer = try topContainer.nestedUnkeyedContainer(forKey: .locations)
        
        var tempLocations = [RiteAidStoreLocation]()
        while(!nestedUnkeyedContainer.isAtEnd) {
            let storeContainer = try nestedUnkeyedContainer.nestedContainer(keyedBy: NestedKey.self)
            let store = try storeContainer.decode(RiteAidStoreLocation.self, forKey: .loc)
            tempLocations.append(store)
        }
        
        locations = tempLocations
    }
}


struct RiteAidStoreLocation:Decodable {
    
    let address1: String
    let city: String
    let state: String
    let corporateCode: String
}
