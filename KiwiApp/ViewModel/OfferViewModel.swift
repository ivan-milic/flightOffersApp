//
//  OfferViewModel.swift
//  KiwiApp
//
//  Created by Ivan Milic on 22.5.21..
//

import Foundation

class OfferViewModel {
    var offer: OfferModel
    
    var flightSummary: String = ""
    var price: String = ""
    var departureLocation: String = ""
    var arrivalLocation: String = ""
    var departureTime: String = ""
    var arrivalTime: String = ""
    var departure: String = ""
    var arrival: String = ""
    var flightDuration: String = ""
    var availableSeats: String = ""
    var stopovers: String = ""
    var destinationImageUrl: URL?
    
    init(offer: OfferModel) {
        self.offer = offer
        setupProperties()
    }
    
    func setupProperties() {
        flightSummary = "\(offer.cityFrom) → \(offer.cityTo)"
        price = "\(offer.price) eur"
        
        departureLocation = "\(offer.cityFrom), \(offer.countryFromName)"
        arrivalLocation = "\(offer.cityTo), \(offer.countryToName)"
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy HH:mm"
        departureTime = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(offer.departureTime)))
        arrivalTime = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(offer.arrivalTime)))
        departure = "\(departureLocation) \(departureTime)"
        arrival = "\(arrivalLocation) \(arrivalTime)"
        
        flightDuration = offer.flyDuration
        if let availableSeats = offer.availableSeats {
            self.availableSeats = "\(availableSeats)"
        }
        stopovers = offer.routes.count == 1 ? "Nonstop" : "\(offer.routes.count - 1)"
        destinationImageUrl = URL(string: "https://images.kiwi.com/photos/600x330/\(offer.mapIdTo).jpg")
    }
}
