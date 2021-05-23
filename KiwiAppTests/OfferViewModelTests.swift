//
//  OfferViewModelTests.swift
//  KiwiAppTests
//
//  Created by Ivan Milic on 23.5.21..
//

import XCTest
@testable import KiwiApp

class OfferViewModelTests: XCTestCase {

    func testViewModelSetup() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "offer1", ofType: "json") else {
            XCTFail("Missing file offer1.json")
            return
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let offer = try JSONDecoder().decode(OfferModel.self, from: data)
        let offerVM = OfferViewModel(offer: offer)
        
        XCTAssertEqual(offerVM.offer, offer)
        XCTAssertEqual(offerVM.flightSummary, "Wrocław → Palma, Majorca")
        XCTAssertEqual(offerVM.price, "72 eur")
        XCTAssertEqual(offerVM.departureLocation, "Wrocław, Poland")
        XCTAssertEqual(offerVM.arrivalLocation, "Palma, Majorca, Spain")
        XCTAssertEqual(offerVM.departureTime, "25 May 2021 11:45")
        XCTAssertEqual(offerVM.arrivalTime, "25 May 2021 14:30")
        XCTAssertEqual(offerVM.departure, "Wrocław, Poland 25 May 2021 11:45")
        XCTAssertEqual(offerVM.arrival, "Palma, Majorca, Spain 25 May 2021 14:30")
        XCTAssertEqual(offerVM.flightDuration, "2h 45m")
        XCTAssertEqual(offerVM.availableSeats, "8")
        XCTAssertEqual(offerVM.stopovers, "Nonstop")
        XCTAssertEqual(offerVM.destinationImageUrl, URL(string: "https://images.kiwi.com/photos/600x330/palma_es.jpg"))
    }
    
    func testStopoversSeats() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "offer2", ofType: "json") else {
            XCTFail("Missing file offer2.json")
            return
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let offer = try JSONDecoder().decode(OfferModel.self, from: data)
        let offerVM = OfferViewModel(offer: offer)
        
        XCTAssertEqual(offerVM.stopovers, "1")
        XCTAssertEqual(offerVM.availableSeats, "")
    }

}
