//
//  ContentView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/6/21.
//

import SwiftUI

struct HomeContentView: View {
    
    var userRegionStore = RegionDataStore()
    
    @State private var showingRegionSettings = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: nil, content: {
                Text("Welcome to VaxSeen!")
                    .font(.title)
                    .padding()
                Text("Choose a pharmacy below to check for appointments")
                    .multilineTextAlignment(.center)
                    .padding()
                NavigationLink(destination: CVSStoreListView()) {
                    Text("CVS")
                        .frame(width: 100, height: 60, alignment: .center)
                        .border(Color.red, width: 5)
                        .cornerRadius(5)
                }
                .padding()
            })
            .toolbar {
                Button {
                    showingRegionSettings.toggle()
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $showingRegionSettings, content: {
            RegionPickerView(isPresented: $showingRegionSettings)
        })
        .environmentObject(userRegionStore)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeContentView()
    }
}
