//
//  OffersViewModelTests.swift
//  OffersViewModelTests
//
//  Created by Ivan Milic on 17.5.21..
//

import XCTest
@testable import KiwiApp

class OffersViewModelTests: XCTestCase {

    private var userDefaults: UserDefaults!
    private var networkManager: NetworkManager!
    private var formatter: DateFormatter!
    private var offersViewModelSUT: OffersViewModel!
    
    override func setUp() {
        super.setUp()
        
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        networkManager = MockNetworkManager()
        formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        offersViewModelSUT = OffersViewModel(userDefaults: userDefaults, networkManager: networkManager)
    }

    override func tearDown() {
        userDefaults = nil
        networkManager = nil
        formatter = nil
        offersViewModelSUT = nil
        
        super.tearDown()
    }

    func testGettingSavedOffers() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "offer1", ofType: "json") else {
            XCTFail("Missing file offer1.json")
            return
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let offer = try JSONDecoder().decode(OfferModel.self, from: data)
        let offers = [offer, offer, offer, offer, offer]
        if let data = try? JSONEncoder().encode(offers) {
            self.userDefaults?.setValue(data, forKey: "offers")
            self.userDefaults?.setValue(formatter.string(from: Date()), forKey: "offersUpdated")
        }
        
        offersViewModelSUT.fetchOffers()
        
        XCTAssertEqual(userDefaults.string(forKey: "offersUpdated"), formatter.string(from: Date()))
        XCTAssertEqual(offersViewModelSUT.offers.map {$0.offer}, offers)
    }
    
    func testFetchingOffers() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "response", ofType: "json") else {
            XCTFail("Missing file response.json")
            return
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let response = try JSONDecoder().decode(Response.self, from: data)
        
        self.userDefaults?.setValue("01/01/1980", forKey: "offersUpdated")
        offersViewModelSUT.fetchOffers()
        XCTAssertEqual(userDefaults.string(forKey: "offersUpdated"), formatter.string(from: Date()))
        XCTAssertTrue(offersViewModelSUT.offers.map {$0.offer}.allSatisfy { response.data.contains($0) })
    }
    
    func testFetchingOffersAlreadyShown() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "offer1", ofType: "json") else {
            XCTFail("Missing file offer1.json")
            return
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let offer = try JSONDecoder().decode(OfferModel.self, from: data)
        let offers = [offer, offer, offer, offer, offer]
        if let data = try? JSONEncoder().encode(offers) {
            self.userDefaults?.setValue(data, forKey: "offers")
            self.userDefaults?.setValue("01/01/1980", forKey: "offersUpdated")
        }
        offersViewModelSUT.fetchOffers()
        XCTAssertEqual(userDefaults.string(forKey: "offersUpdated"), formatter.string(from: Date()))
        XCTAssertEqual(offersViewModelSUT.offers.map {$0.offer}.count, 5)
        XCTAssertTrue(offersViewModelSUT.offers.map {$0.offer}.allSatisfy { !offers.contains($0) })
    }
    
    func testFetchingOffersNotShown() throws {
        guard let path1 = Bundle(for: type(of: self)).path(forResource: "offer2", ofType: "json") else {
            XCTFail("Missing file offer2.json")
            return
        }
        let data1 = try Data(contentsOf: URL(fileURLWithPath: path1))
        let offer = try JSONDecoder().decode(OfferModel.self, from: data1)
        let offers = [offer, offer, offer, offer, offer]
        if let data = try? JSONEncoder().encode(offers) {
            self.userDefaults?.setValue(data, forKey: "offers")
            self.userDefaults?.setValue("01/01/1980", forKey: "offersUpdated")
        }
        
        guard let path2 = Bundle(for: type(of: self)).path(forResource: "response", ofType: "json") else {
            XCTFail("Missing file response.json")
            return
        }
        let data2 = try Data(contentsOf: URL(fileURLWithPath: path2))
        let response = try JSONDecoder().decode(Response.self, from: data2)
        
        offersViewModelSUT.fetchOffers()
        XCTAssertEqual(userDefaults.string(forKey: "offersUpdated"), formatter.string(from: Date()))
        XCTAssertNotEqual(offersViewModelSUT.offers.map {$0.offer}, offers)
        XCTAssertTrue(offersViewModelSUT.offers.map {$0.offer}.allSatisfy { response.data.contains($0) })
        XCTAssertEqual(offersViewModelSUT.offers.map {$0.offer}.count, 5)
    }
    
    func testSelectOffer() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "response", ofType: "json") else {
            XCTFail("Missing file response.json")
            return
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let response = try JSONDecoder().decode(Response.self, from: data)
        
        offersViewModelSUT.fetchOffers()
        offersViewModelSUT.selectOffer(index: 1)
        XCTAssertNotNil(offersViewModelSUT.selectedOffer)
        XCTAssertEqual(offersViewModelSUT.selectedOffer?.offer, response.data[1])
    }
}
