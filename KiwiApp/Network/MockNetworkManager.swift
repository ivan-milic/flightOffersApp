//
//  MockNetworkManager.swift
//  KiwiApp
//
//  Created by Ivan Milic on 23.5.21..
//

import Foundation
import Combine

class MockNetworkManager: NetworkManager {
    @Published var response: Response?
    
    func fetchOffers(from startDate: String, to endDate: String) -> AnyPublisher<Response?, Error> {
        guard let path = Bundle(for: type(of: self)).path(forResource: "response", ofType: "json") else {
            preconditionFailure()
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let response = try? JSONDecoder().decode(Response.self, from: data) else { preconditionFailure() }
        
        self.response = response
        return $response.map { $0 as Response? }.setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
