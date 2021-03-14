//
//  RegionPickerView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/14/21.
//

import SwiftUI

struct RegionPickerView: View {
    
    @EnvironmentObject var userRegionStore: RegionDataStore
    @State private var selection = Set<SelectableRegion>()
    
    var body: some View {
        List(userRegionStore.selectableRegions, selection: $selection) { (item) in
            HStack(alignment: .center, spacing: 5, content: {
                Text("\(item.region.name)")
                Spacer()
                if selection.contains(item) {
                    Image(systemName: "checkmark.circle.fill")
                }
                else {
                    Image(systemName: "circle")
                }
            })
        }
    }
}

struct RegionPickerView_Previews: PreviewProvider {
    static var previews: some View {
        RegionPickerView()
    }
}
