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
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            TextField("Enter your location",
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
        }
        .navigationTitle("Availability")
    }
    
    @ViewBuilder private var contentPlaceView: some View {
        if controller.isFetchingStores {
            ProgressView("Checking for Openings...")
        }
        else if controller.vaxStores.isEmpty {
            emptyView
        }
        else {
            Spacer()
        }
    }
    
    private var emptyView: some View {
        Text("It doesn't look like there's any appointments near \(queryText). Please try again.")
            .font(.body)
            .multilineTextAlignment(.center)
    }
    
    private var storesView: some View {
        List(controller.vaxStores) { (item) in
            Button(action: {
//                self.showingAlert.toggle()
            },
            label: {
                StoreListItemView(storeItem: item) {
                    selectedMapStore = item
                    activeSheet = .mapView
                }
            })
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
