//
//  CVSController.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/6/21.
//

import Foundation
import Combine



final class CVSController {
    
    // everything hard-coded to PA, for now...
    private static let baseUrlString = "https://www.cvs.com/immunizations/covid-19-vaccine.vaccine-status.PA.json?vaccineinfo"
    private static let refererString = "https://www.cvs.com/immunizations/covid-19-vaccine?icid=cvs-home-hero1-link2-coronavirus-vaccine"
    
    private let session: URLSession
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    @Published var stores = [Store]()
    
    init() {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Referer": CVSController.refererString,
                                        "Content-Type": "application/json"]
        self.session = URLSession(configuration: config)
    }
    
    
    func fetchAppointments() {
        // TODO don't bang
        var request = URLRequest(url: URL(string: CVSController.baseUrlString)!)
        request.httpMethod = "GET"
        let cancellable = session.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
            }
            .decode(type: StoreResponse.self, decoder: JSONDecoder())
            .sink { (_) in
                print("Received value")
            } receiveValue: { [weak self] (storeResponse) in
                print("Received store data")
                self?.stores = storeResponse.stores
            }
        
        cancellable.store(in: &cancellables)
    }
}
