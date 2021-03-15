//
//  RegionPickerView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/14/21.
//

import SwiftUI

struct RegionPickerView: View {
    
    @EnvironmentObject var userRegionStore: RegionDataStore
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                Text("Select the regions you'd like to find appointments in")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                List(userRegionStore.selectableRegions, selection: $userRegionStore.selectedRegions) { (item) in
                    Button(action: {
                        print("Selected State: \(item.code)")
                        if userRegionStore.selectedRegions.contains(item) {
                            userRegionStore.selectedRegions.remove(item)
                        }
                        else {
                            userRegionStore.selectedRegions.insert(item)
                        }
                        for (_, thing) in userRegionStore.selectedRegions.enumerated() {
                            print("item \(thing.code)")
                        }
                    }, label: {
                        HStack(alignment: .center, spacing: 5, content: {
                            Text("\(item.name)")
                            Spacer()
                            if userRegionStore.selectedRegions.contains(item) {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            else {
                                Image(systemName: "circle")
                            }
                        })
                    })
                }
            }
            .navigationBarTitle(
                Text("Region Selection")
            )
        }
    }
}

struct RegionPickerView_Previews: PreviewProvider {
    static var previews: some View {
        RegionPickerView()
    }
}
