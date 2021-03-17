//
//  RiteAidStoreListView.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/17/21.
//

import SwiftUI

struct RiteAidStoreListView: View {
    
    @StateObject private var controller = RiteAidController()
    
    var body: some View {
        Text("Checking Rite Aid....")
            .onAppear {
                controller.getLocation(for: "Philadelphia, PA")
            }
    }
}

struct RiteAidStoreListView_Previews: PreviewProvider {
    static var previews: some View {
        RiteAidStoreListView()
    }
}
