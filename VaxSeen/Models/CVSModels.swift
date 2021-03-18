//
//  CVSModels.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/6/21.
//

import Foundation


fileprivate struct DynamicCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        return nil
    }
}

struct CVSStoreResponse: Decodable {
    
    enum Keys: String, CodingKey {
        case responsePayloadData
    }
    
    enum DataKeys: String, CodingKey {
        case data
    }
    
    let stores: [CVSStoreLocation]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        let nestedContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .responsePayloadData)
        let statesContainer = try nestedContainer.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .data)
        
        var tempStores = [CVSStoreLocation]()
        
        for key in statesContainer.allKeys {
            if let codingKey = DynamicCodingKey(stringValue: key.stringValue) {
                let stores = try statesContainer.decode([CVSStoreLocation].self, forKey: codingKey)
                tempStores.append(contentsOf: stores)
            }
        }
        
        self.stores = tempStores
    }
}

struct CVSStoreLocation: Decodable, Identifiable {
    
    static let cvsCovidQuestionUrl = "https://www.cvs.com/vaccine/intake/store/covid-screener/covid-qns"
    
    enum Keys: String, CodingKey {
        case city
        case state
        case status
    }
    
    let city: String
    let state: String
    let status: String
    
    let id: UUID
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        status = try container.decode(String.self, forKey: .status)
        
        id = UUID()
    }
    
    init(city: String, state: String, status: String) {
        id = UUID()
        self.city = city
        self.state = state
        self.status = status
    }
    
    static let testStore = CVSStoreLocation(city: "Philadelphia", state: "PA", status: "Available")
}

extension CVSStoreLocation {
    
    var hasAppointments: Bool {
        return status == "Available"
    }
}

extension CVSStoreLocation: StoreIdentifiable {
    
    var titleDescription: String {
        return "CVS \(city)"
    }
    
    var detailDescription: String {
        return "\(city), \(state)"
    }    
}
