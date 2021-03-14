//
//  ContentView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/6/21.
//

import SwiftUI

struct ContentView: View {
    
    var userRegionStore = RegionDataStore()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: nil, content: {
                Text("Welcome to VaxSeen!")
                    .font(.title)
                    .padding()
                Text("Choose a pharmacy below to check for appointments")
                    .multilineTextAlignment(.center)
                    .padding()
                NavigationLink(destination: StoreListView()) {
                    Text("CVS")
                        .frame(width: 100, height: 60, alignment: .center)
                        .border(Color.red, width: 5)
                        .cornerRadius(5)
                }
                .padding()
                Text("Currently checking NJ, DE and PA")
                    .font(.footnote)
            })
        }
        .environmentObject(userRegionStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
