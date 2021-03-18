//
//  CVSStoreListView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/7/21.
//

import SwiftUI

fileprivate enum ActiveSheet: Identifiable {
    case settings
    case mapView
    
    var id: Int {
        return hashValue
    }
}

struct CVSStoreListView: View {
    
    @EnvironmentObject var userRegionStore: RegionDataStore
    
    @ObservedObject var storeFeed = CVSController()
    @State private var showingAlert = false
    @State private var showingRegionSettings = false
    @State private var selectedMapStore: Store? = nil
    @State private var activeSheet: ActiveSheet?
    
    var body: some View {
        dataView
            .navigationTitle("Stores")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingRegionSettings.toggle()
                        activeSheet = .settings
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(item: $activeSheet,
                   onDismiss: {
                        reloadStoreFeed()
                   },
                   content: { (item) in
                    switch(item) {
                        case .settings:
                            RegionPickerView(isPresented: $showingRegionSettings)
                        case .mapView:
                            if let mapStore = selectedMapStore {
                                StoreMapView(store: mapStore)
                            }
                            else {
                                Text("Unknown Error, Try Again")
                            }
                    }
            })
//            .sheet(isPresented: $showingRegionSettings, onDismiss: {
//                reloadStoreFeed()
//            }, content: {
//                RegionPickerView(isPresented: $showingRegionSettings)
//            })
            .onAppear {
                reloadStoreFeed()
            }
    }
    
    @ViewBuilder var dataView: some View {
        if storeFeed.isFetchingStores {
            ProgressView("Checking for Openings...")
        }
        else if storeFeed.stores.isEmpty {
            emptyView
        }
        else {
            storesView
        }
    }
    
    var emptyView: some View {
        VStack(alignment: .center, spacing: 40, content: {
            Text("It doesn't look like there's any appointments available for your selected regions. Please try again.")
                .font(.body)
                .multilineTextAlignment(.center)
            Button("Check Again") {
                reloadStoreFeed()
            }
            .frame(width: 150, height: 60, alignment: .center)
            .border(Color.blue, width: 2)
            .cornerRadius(5.0)
        })
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
    }
    
    var storesView: some View {
        VStack(alignment: .center, spacing: 10) {
            if !userRegionStore.selectedRegions.isEmpty {
                Text("Showing results for: \n \(userRegionStore.selectedRegions.map({ $0.name }).joined(separator: ", "))")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.all, 15)
            }
            List(storeFeed.stores) { (item) in
                Button(action: {
                    self.showingAlert.toggle()
                },
                label: {
                    StoreListItemView(storeItem: item) {
                        selectedMapStore = item
                        activeSheet = .mapView
                    }
                })
            }
        }
//        .sheet(item: $selectedMapStore, content: { (mapStore) in
//            StoreMapView(store: mapStore)
//        })
        .alert(isPresented: self.$showingAlert,
               content: {
                Alert(title: Text("Book now!"),
                      message: Text("Continue to the CVS website to book"),
                      primaryButton: .default(Text("Continue"),
                                              action: {
                                                self.showingAlert = false
                                                if let url = URL(string: Store.cvsCovidQuestionUrl) {
                                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                }
                                              }),
                      secondaryButton: .cancel({
                        self.showingAlert = false
                      })
                )
        })
    }
    
    private func reloadStoreFeed() {
        let selectedRegions = Array(userRegionStore.selectedRegions)
        let regionCodes = selectedRegions.map({ $0.code })
        storeFeed.fetchAppointments(regionCodes: regionCodes)
    }
}

struct StoreListView_Previews: PreviewProvider {
    static var previews: some View {
        CVSStoreListView()
    }
}
