//
//  NetworkManager.swift
//  KiwiApp
//
//  Created by Ivan Milic on 23.5.21..
//

import Foundation
import Combine

protocol NetworkManager {
    func fetchOffers(from startDate: String, to endDate: String) -> AnyPublisher<Response?, Error>
}

class SkypickerNetworkManager: NetworkManager {
    let kBaseUrl = "https://api.skypicker.com"
    let kPartnerId = "milic92test2"
    
    static let shared = SkypickerNetworkManager()
    
    private init() {}
    
    func fetchOffers(from startDate: String, to endDate: String) -> AnyPublisher<Response?, Error> {
        let urlString = "\(kBaseUrl)/flights?v=3&sort=popularity&asc=0&locale=en&daysInDestinationFrom=&daysInDestinationTo=&affilid=&children=0&infants=0&flyFrom=49.2-16.61-250km&to=anywhere&featureName=aggregateResults&dateFrom=\(startDate)&dateTo=\(endDate)&typeFlight=oneway&returnFrom=&returnTo=&one_per_date=0&oneforcity=1&wait_for_refresh=0&adults=1&limit=45&partner=\(self.kPartnerId)"
        guard let url = URL(string: urlString) else { preconditionFailure("Can't create url for query") }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Response?.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
