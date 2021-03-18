//
//  StoreListItemView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/9/21.
//

import SwiftUI

struct StoreListItemView<T: StoreIdentifiable>: View {
    
    let storeItem: T
    let directionsHandler: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 10, content: {
            VStack(alignment: .leading, spacing: 10, content: {
                Text(storeItem.titleDescription)
                    .font(.title2)
                Text(storeItem.detailDescription)
                    .font(.body)
            })
            Spacer(minLength: 5)
            Button(
                action: directionsHandler,
                label: {
                    Image(systemName: "map")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
            )
            .onTapGesture {
                directionsHandler()
            }
            .buttonStyle(BorderlessButtonStyle())
        })
    }
}

struct StoreListItemView_Previews: PreviewProvider {
    static var previews: some View {
        StoreListItemView(storeItem: CVSStoreLocation.testStore) {
            /* no op */
        }
    }
}
