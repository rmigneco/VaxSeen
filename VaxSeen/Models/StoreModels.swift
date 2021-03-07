//
//  StoreModels.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/6/21.
//

import Foundation

struct StoreResponse: Decodable {
    
    enum Keys: String, CodingKey {
        case responsePayloadData
    }
    
    enum DataKeys: String, CodingKey {
        case data
    }
    
    // TODO: make more dynamic
    enum StateKeys: String, CodingKey {
        case pa = "PA"
    }
    
    let stores: [Store]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let nestedContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .responsePayloadData)
        let stateContainer = try nestedContainer.nestedContainer(keyedBy: StateKeys.self, forKey: .data)
        
        self.stores = try stateContainer.decode([Store].self, forKey: .pa)
    }
}

struct Store: Decodable {
    let city: String
    let state: String
    let status: String
}

extension Store {
    
    var hasAppointments: Bool {
        return status == "Available"
    }
}
