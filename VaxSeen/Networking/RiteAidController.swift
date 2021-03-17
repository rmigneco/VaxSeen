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
    
    private let session: URLSession
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    init(){
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["referer": "https://www.riteaid.com/locations/",
                                        "accept": "application/json"]
        
        self.session = URLSession(configuration: config)
    }
    
    func getLocation(for query: String) {
        guard let url = URL(string: "https://www.riteaid.com/locations/search.html"),
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
                    print("Finished Request")
                case .failure(let error):
                    print("Request failed with Error: \(error)")
                }
            } receiveValue: { response in
                print("received value")
            }
            .store(in: &cancellables)
        
    }
    
    // view modifier
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
}
