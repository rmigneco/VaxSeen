//
//  RiteAidController.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/16/21.
//

import Foundation
import Combine


final class RiteAidController: ObservableObject {
    
    private static let storeLocatorUrlString = "https://www.riteaid.com/locations/search.html"
    private static let checkSlotsUrlString = "https://www.riteaid.com/services/ext/v2/vaccine/checkSlots"
    
    private let session: URLSession
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    init(){
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["referer": "https://www.riteaid.com/locations/",
                                        "accept": "application/json"]
        
        self.session = URLSession(configuration: config)
    }
    
    func getLocation(for query: String) {
        guard let url = URL(string: RiteAidController.storeLocatorUrlString),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return
        }
        
        components.queryItems = [URLQueryItem(name: "q", value: query)]
        guard let searchURL = components.url else { return }
        var request = URLRequest(url: searchURL)
        request.httpMethod = "GET"
        
        session.dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200
                else {
                    throw URLError(.badServerResponse)
                }
                
                return element.data
            }
            .decode(type: RiteAidLocationResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink { result in
                switch result {
                case .finished:
                    print("Finished Store Response Request")
                case .failure(let error):
                    print("Store Response Request failed with Error: \(error)")
                }
            } receiveValue: { [weak self] response in
                print("Store Response")
                self?.requestAvailability(for: response.locations)
            }
            .store(in: &cancellables)
    }
    
    private func requestAvailability(for stores: [RiteAidStoreLocation]) {
        
        // may be a more elegant way of doing this
        // https://stackoverflow.com/questions/66320320/swift-combine-sink-array-anypublisher
        // might need to look at publisher type as AnyPublisher<Result<StoreLocation, Error>, Never>
        
        let publishers = stores.map({ publisher(for: $0)}).compactMap({ $0 })
        
        Publishers.MergeMany(publishers)
            .receive(on: DispatchQueue.main)
            .sink { (result) in
                switch(result) {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print("Finished with Error: \(error)")
                }
            } receiveValue: { (value) in
                print("Received value: \(value)")
            }
            .store(in: &cancellables)
        
        // old school way of doing it
//        let dispatchGroup = DispatchGroup()
//        var tempStores = [RiteAidStoreLocation]()
//
//        for store in stores {
//            dispatchGroup.enter()
//            checkAvailability(for: store) { (available) in
//                if available {
//                    store.hasAppointments = true
//                    tempStores.append(store)
//                }
//                dispatchGroup.leave()
//            }
//        }
//
//        dispatchGroup.notify(qos: .userInitiated, queue: .main) {
//            print("\(tempStores.count) stores with avail")
//        }
    }
    
    private func checkAvailability(for store: RiteAidStoreLocation, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: RiteAidController.checkSlotsUrlString),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            completion(false)
            
            return
        }
        
        components.queryItems = [URLQueryItem(name: "storeNumber", value: store.corporateCode)]
        guard let requestUrl = components.url else {
            completion(false)
            
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        session.dataTaskPublisher(for: request)
            .tryMap { (result) -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return result.data
            }
            .decode(type: RiteAidStoreAvailability.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { (result) in
                switch(result) {
                case .failure(let error):
                    print("Store Avail request failed: Error \(error)")
                    completion(false)
                case .finished:
                    print("Finished Store Avail request")
                }
            }, receiveValue: { (result) in
                completion(result.hasAppointments)
            })
            .store(in: &cancellables)
    }
    
    private func publisher(for store: RiteAidStoreLocation) -> AnyPublisher<RiteAidStoreLocation, Error>? {
        guard let url = URL(string: RiteAidController.checkSlotsUrlString),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        
        components.queryItems = [URLQueryItem(name: "storeNumber", value: store.corporateCode)]
        guard let requestUrl = components.url else {
            return nil
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let publisher = session.dataTaskPublisher(for: request)
            .tryMap { (result) -> Data in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return result.data
            }
            .decode(type: RiteAidStoreAvailability.self, decoder: JSONDecoder())
            .map({ (availability) -> RiteAidStoreLocation in
                store.hasAppointments = availability.hasAppointments
                
                return store
            })
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    // view modifier
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
}
