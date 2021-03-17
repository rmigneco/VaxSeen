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


final class RiteAidStoreLocation: Decodable {
    
    enum Keys: String, CodingKey {
        case address1
        case city
        case state
        case corporateCode
    }
    
    let address1: String
    let city: String
    let state: String
    let corporateCode: String
    
    var hasAppointments = false
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        address1 = try container.decode(String.self, forKey: .address1)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        corporateCode = try container.decode(String.self, forKey: .corporateCode)
    }
}
