//
//  RiteAidStoreListView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/17/21.
//

import SwiftUI

struct RiteAidStoreListView: View {
    
    @StateObject private var controller = RiteAidController()
    
    @State private var queryText: String = ""
    @State private var showingAlert = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            TextField("Enter your location (e.g. New York or 16801)",
                      text: $queryText,
                      onEditingChanged: { isEditing in
                        // isEditing = true when user begins editing text
                      }, onCommit: {
                        controller.getLocation(for: queryText)
                        // TODO: stored prefereed location? Refresh On Appear
                      })
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(20)
            Spacer()
            contentPlaceView
            Spacer()
        }
        .navigationTitle("Availability")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private var contentPlaceView: some View {
        if controller.isFetchingStores {
            ProgressView("Checking for Openings...")
        }
        else if controller.vaxStores.isEmpty {
            emptyView
        }
        else {
            storesView
        }
    }
    
    private var emptyView: some View {
        VStack(alignment: .center, spacing: 5) {
            Text("No Appointments!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
            Text("Enter a location to find appointments")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(20)
        }
    }
    
    private var storesView: some View {
        List(controller.vaxStores) { (item) in
            Button(action: {
                self.showingAlert.toggle()
            },
            label: {
                StoreListItemView(storeItem: item) {
//                    selectedMapStore = item
//                    activeSheet = .mapView
                }
            })
        }
        .alert(isPresented: self.$showingAlert) {
            Alert(title: Text("Book now!"),
                  message: Text("Continue to the RiteAid website to book"),
                  primaryButton: .default(Text("Continue"),
                                          action: {
                                            self.showingAlert = false
                                            if let url = URL(string: RiteAidStoreLocation.scheduleURLString) {
                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                            }
                                          }),
                  secondaryButton: .cancel({
                    self.showingAlert = false
                  })
            )
        }
    }
    
    // view modifier
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
}

struct RiteAidStoreListView_Previews: PreviewProvider {
    static var previews: some View {
        RiteAidStoreListView()
    }
}
