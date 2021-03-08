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
                VStack(alignment: .leading, spacing: 5, content: {
                    Text("\(item.city), \(item.state)")
                    Text(item.hasAppointments ? "Availabilty!" : "No Availability")
                })
            }
        }
        .navigationTitle("Stores")
        .onAppear {
            storeFeed.fetchAppointments()
        }
    }
}

struct StoreLIstView_Previews: PreviewProvider {
    static var previews: some View {
        StoreListView()
    }
}
