//
//  CVSController.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/6/21.
//

import Foundation
import Combine



final class CVSController: ObservableObject {
    
    // everything hard-coded to PA, for now...
    private static let baseUrlString = "https://www.cvs.com/immunizations/covid-19-vaccine.vaccine-status.PA.json?vaccineinfo"
    private static let refererString = "https://www.cvs.com/immunizations/covid-19-vaccine?icid=cvs-home-hero1-link2-coronavirus-vaccine"
    
    private let session: URLSession
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    private let onlyShowAvailableAppointments = true
    
    @Published var stores = [CVSStoreLocation]()
    @Published var isFetchingStores = false
    
    init() {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Referer": CVSController.refererString,
                                        "Content-Type": "application/json"]
        self.session = URLSession(configuration: config)
    }
    
    func fetchAppointments(regionCodes: [String]) {
        stores.removeAll()
        
        guard !regionCodes.isEmpty else { return }
        
        let publishers = regionCodes.map { (code) -> AnyPublisher<CVSStoreResponse, Error>? in
            generatePublisher(for: code)
        }.compactMap({$0})
        
        isFetchingStores = true
        
        Publishers.MergeMany(publishers)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (result) in
                self?.isFetchingStores = false 
                switch result {
                case .finished:
                    print("Finished Request")
                case .failure(let error):
                    print("Request failed with Error: \(error)")
                }
            } receiveValue: { [weak self] (response) in
                let showAvailable = self?.onlyShowAvailableAppointments ?? true
                self?.stores.append(contentsOf: response.stores.filter({ showAvailable ? $0.hasAppointments : true }))
            }
            .store(in: &cancellables)

    }
    
    private func generatePublisher(for stateCode: String) -> AnyPublisher<CVSStoreResponse, Error>? {
        guard let url = URL(string: "https://www.cvs.com/immunizations/covid-19-vaccine.vaccine-status." + stateCode + ".json?vaccineinfo") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let publisher = session.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                
                return element.data
            }
            .decode(type: CVSStoreResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        return publisher
    }
}
