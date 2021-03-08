//
//  StoreLIstView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/7/21.
//

import SwiftUI

struct StoreListView: View {
    
    @ObservedObject var storeFeed = CVSController()
    
    var body: some View {
        NavigationView {
            List(storeFeed.stores) { (item) in
                VStack(alignment: .leading, spacing: 10, content: {
                    Text(item.hasAppointments ? "Availabilty!" : "No Availability")
                        .font(.title2)
                    Text("\(item.city), \(item.state)")
                        .font(.body)
                })
            }
        }
        .navigationTitle("Stores")
        .onAppear {
            storeFeed.fetchAppointments()
        }
    }
}

struct StoreListView_Previews: PreviewProvider {
    static var previews: some View {
        StoreListView()
    }
}
