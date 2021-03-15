//
//  RegionPickerView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/14/21.
//

import SwiftUI

struct RegionPickerView: View {
    
    @EnvironmentObject var userRegionStore: RegionDataStore
    @State private var selection: Set<Region> = [
        Region(name: "Pennsylvania", code: "PA"),
        Region(name: "New Jersey", code: "NJ")
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                Text("Select the regions you'd like to find appointments in")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                List(userRegionStore.selectableRegions, selection: $selection) { (item) in
                    Button(action: {
                        print("Selected State: \(item.code)")
                        if selection.contains(item) {
                            selection.remove(item)
                        }
                        else {
                            selection.insert(item)
                        }
                        for (index, thing) in selection.enumerated() {
                            print("item \(thing.code)")
                        }
                    }, label: {
                        HStack(alignment: .center, spacing: 5, content: {
                            Text("\(item.name)")
                            Spacer()
                            if selection.contains(item) {
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
