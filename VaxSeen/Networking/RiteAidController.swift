//
//  RiteAidController.swift
//  VaxSeen
//
//  Created by Ray Migneco on 3/16/21.
//

import Foundation
import Combine


final class RiteAidController: ObservableObject {
    
//    :method: GET
//    :scheme: https
//    :path: /locations/search.html?q=Philadelphia%2C+PA
//    :authority: www.riteaid.com
//    accept: application/json
//    accept-encoding: gzip, deflate, br
//    user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.2 Safari/605.1.15
//    accept-language: en-us
//    referer: https://www.riteaid.com/locations/search.html?q=Philadelphia%2C+PA
    
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
        let publishers = stores.map { (store) -> AnyPublisher<String, Error>? in
            return publisher(for: store.corporateCode)
        }
        .compactMap({ $0 })
        
        Publishers.MergeMany(publishers)
            .sink { (result) in
                switch(result) {
                case .failure(let error):
                    print("Failed with Error \(error)")
                case .finished:
                    print("Finished")
                }
            } receiveValue: { (dummyString) in
                // TODO: append available stores
                print("received value")
            }
            .store(in: &cancellables)
    }
    
    private func publisher(for storeId: String) -> AnyPublisher<String, Error>? {
        guard let url = URL(string: RiteAidController.checkSlotsUrlString),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        
        components.queryItems = [URLQueryItem(name: "storeNumber", value: storeId)]
        
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
            .decode(type: String.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        return publisher
    }
    
    // view modifier
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
}
