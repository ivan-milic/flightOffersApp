//
//  OfferModel.swift
//  KiwiApp
//
//  Created by Ivan Milic on 18.5.21..
//

import Foundation

struct Response: Codable {
    var data: [OfferModel]
}

struct OfferModel: Codable {
    var id: String
    var cityFrom: String
    var cityTo: String
    var countryFromName: String
    var countryToName: String
    var mapIdTo: String
    var price: Int
    var availableSeats: Int?
    var flyDuration: String
    var departureTime: Int
    var arrivalTime: Int
    var routes: [Route]
    
    // Top-level coding keys
    enum CodingKeys: String, CodingKey {
        case id, cityFrom, cityTo, countryFrom, countryTo, price, availability, dTime, aTime, route
        case mapIdTo = "mapIdto"
        case flyDuration = "fly_duration"
    }

    enum CountryFromKeys: CodingKey {
      case name
    }

    enum CountryToKeys: CodingKey {
        case name
    }

    enum AvailabilityKeys: CodingKey {
        case seats
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        cityFrom = try container.decode(String.self, forKey: .cityFrom)
        cityTo = try container.decode(String.self, forKey: .cityTo)
        let countryFrom = try container.nestedContainer(keyedBy: CountryFromKeys.self, forKey: .countryFrom)
        countryFromName = try countryFrom.decode(String.self, forKey: .name)
        let countryTo = try container.nestedContainer(keyedBy: CountryToKeys.self, forKey: .countryTo)
        countryToName = try countryTo.decode(String.self, forKey: .name)
        mapIdTo = try container.decode(String.self, forKey: .mapIdTo)
        price = try container.decode(Int.self, forKey: .price)
        let availability = try container.nestedContainer(keyedBy: AvailabilityKeys.self, forKey: .availability)
        availableSeats = try? availability.decode(Int.self, forKey: .seats)
        flyDuration = try container.decode(String.self, forKey: .flyDuration)
        departureTime = try container.decode(Int.self, forKey: .dTime)
        arrivalTime = try container.decode(Int.self, forKey: .aTime)
        routes = try container.decode([Route].self, forKey: .route)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(cityFrom, forKey: .cityFrom)
        try container.encode(cityTo, forKey: .cityTo)
        var countryFrom = container.nestedContainer(keyedBy: CountryFromKeys.self, forKey: .countryFrom)
        try countryFrom.encode(countryFromName, forKey: .name)
        var countryTo = container.nestedContainer(keyedBy: CountryToKeys.self, forKey: .countryTo)
        try countryTo.encode(countryToName, forKey: .name)
        try container.encode(mapIdTo, forKey: .mapIdTo)
        try container.encode(price, forKey: .price)
        var availability = container.nestedContainer(keyedBy: AvailabilityKeys.self, forKey: .availability)
        try availability.encode(availableSeats, forKey: .seats)
        try container.encode(flyDuration, forKey: .flyDuration)
        try container.encode(departureTime, forKey: .dTime)
        try container.encode(arrivalTime, forKey: .aTime)
        try container.encode(routes, forKey: .route)
    }
}

extension OfferModel: Equatable { }

struct Route: Codable {
    var cityFrom: String
    var cityTo: String
}

extension Route: Equatable { }
