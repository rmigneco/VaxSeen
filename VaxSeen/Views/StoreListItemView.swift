//
//  StoreListItemView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/9/21.
//

import SwiftUI

struct StoreListItemView: View {
    
    let storeItem: Store
    let directionsHandler: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 10, content: {
            VStack(alignment: .leading, spacing: 10, content: {
                Text(storeItem.hasAppointments ? "Appointments Available!" : "No Availability")
                    .font(.title2)
                Text("\(storeItem.city), \(storeItem.state)")
                    .font(.body)
            })
            Spacer(minLength: 5)
            Button(
                action: {},
                label: {
                    Image(systemName: "map")
                        .font(.largeTitle)
                }
            )
            .onTapGesture {
                directionsHandler()
            }
        })
    }
}

struct StoreListItemView_Previews: PreviewProvider {
    static var previews: some View {
        StoreListItemView(storeItem: Store.testStore) {
            /* no op */
        }
    }
}
