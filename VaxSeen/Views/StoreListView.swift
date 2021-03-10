//
//  StoreLIstView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/7/21.
//

import SwiftUI

struct StoreListView: View {
    
    @ObservedObject var storeFeed = CVSController()
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            dataView
        }
        .navigationTitle("Stores")
        .onAppear {
            storeFeed.fetchAppointments()
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
            Text("It doesn't look like there's any appointments available. Please try again.")
                .font(.body)
                .multilineTextAlignment(.center)
            Button("Check Again") {
                storeFeed.fetchAppointments()
            }
            .frame(width: 150, height: 60, alignment: .center)
            .border(Color.blue, width: 2)
            .cornerRadius(5.0)
        })
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
    }
    
    var storesView: some View {
        List(storeFeed.stores) { (item) in
            StoreListItemView(storeItem: item) {
                print("Map Handler")
                // In the handler
            }
//            Button(action: {
//                self.showingAlert = true
//            },
//            label: {
//                VStack(alignment: .leading, spacing: 10, content: {
//                    Text(item.hasAppointments ? "Appointments Available!" : "No Availability")
//                        .font(.title2)
//                    Text("\(item.city), \(item.state)")
//                        .font(.body)
//                })
//            })
        }
        .alert(isPresented: self.$showingAlert,
               content: {
                Alert(title: Text("Book now!"),
                      message: Text("Continue to the CVS website to book"),
                      primaryButton: .default(Text("Continue"),
                                              action: {
                                                self.showingAlert = false
                                                if let url = URL(string: "https://www.cvs.com/vaccine/intake/store/covid-screener/covid-qns") {
                                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                }
                                              }),
                      secondaryButton: .cancel({
                        self.showingAlert = false
                      })
                )
        })
    }
}

struct StoreListView_Previews: PreviewProvider {
    static var previews: some View {
        StoreListView()
    }
}
