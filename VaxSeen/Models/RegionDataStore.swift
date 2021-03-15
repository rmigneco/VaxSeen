//
//  RegionDataStore.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/14/21.
//

import Foundation


struct SelectableRegion: Codable {
    let region: Region
    let isSelected: Bool
}

extension SelectableRegion: Identifiable {
    var id: String {
        return region.code
    }
}

extension SelectableRegion: Hashable { }

struct Region: Codable {
    let name: String
    let code: String
}

extension Region: Identifiable {
    var id: String {
        return code
    }
}

extension Region: Hashable { }

extension Region {
    
    static var allRegions: [Region] = [
        Region(name: "Alabama", code: "AL"),
        Region(name: "Arizona", code: "AZ"),
        Region(name: "Arkansas", code: "AK"),
        Region(name: "California", code: "CA"),
        Region(name: "Colorado", code: "CO"),
        Region(name: "Connecticut", code: "CT"),
        Region(name: "Delaware", code: "DE"),
        Region(name: "Florida", code: "FL"),
        Region(name: "Georgia", code: "GA"),
        Region(name: "Hawaii", code: "HI"),
        Region(name: "Illinois", code: "IL"),
        Region(name: "Indiana", code: "IN"),
        Region(name: "Iowa", code: "IA"),
        Region(name: "Kentucky", code: "KY"),
        Region(name: "Louisiana", code: "LA"),
        Region(name: "Maryland", code: "MD"),
        Region(name: "Massachusetts", code: "MA"),
        Region(name: "Minnesota", code: "MN"),
        Region(name: "Missouri", code: "MO"),
        Region(name: "Montana", code: "MT"),
        Region(name: "Nevada", code: "NV"),
        Region(name: "New Jersey", code: "NJ"),
        Region(name: "New York", code: "NY"),
        Region(name: "North Carolina", code: "NC"),
        Region(name: "North Dakota", code: "ND"),
        Region(name: "Ohio", code: "OH"),
        Region(name: "Oklahoma", code: "OK"),
        Region(name: "Pennsylvania", code: "PA"),
        Region(name: "Puerto Rico", code: "PR"),
        Region(name: "Rhode Island", code: "RI"),
        Region(name: "South Carolina", code: "SC"),
        Region(name: "Texas", code: "TX"),
        Region(name: "Utah", code: "UT"),
        Region(name: "Vermont", code: "VT"),
        Region(name: "Virginia", code: "VA")
    ]
}


final class RegionDataStore: ObservableObject {
    
    private static let storedUserRegions = "com.vaxseen.userRegions"
    
    @Published var selectableRegions: [Region]
    @Published var selectedRegions:Set<Region>
    
    init() {
        // get stored states
        var storedRegions = [Region]()
        if let data = UserDefaults.standard.data(forKey: RegionDataStore.storedUserRegions) {
            let decoder = JSONDecoder()
            storedRegions = (try? decoder.decode([Region].self, from: data)) ?? [Region]()
        }
        
        self.selectedRegions = Set<Region>(storedRegions)
        selectableRegions = [Region]()
        selectableRegions.append(contentsOf: Region.allRegions)
    }
    
    // TODO: need methods to save 
    
}
