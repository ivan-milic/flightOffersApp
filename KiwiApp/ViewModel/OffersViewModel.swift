//
//  OffersViewModel.swift
//  KiwiApp
//
//  Created by Ivan Milic on 23.5.21..
//

import Foundation
import Combine

class OffersViewModel {
    
    @Published var offers = [OfferViewModel]()
    var selectedOffer: OfferViewModel?
    
    private var userDefaults: UserDefaults?
    private var networkManager: NetworkManager?
    
    private let formatter = DateFormatter()
    private var savedOffers: [OfferModel]?
    private var cancellables: [AnyCancellable] = []
    
    let kDailyOffersNumber = 5
    
    init(userDefaults: UserDefaults = .standard, networkManager: NetworkManager = SkypickerNetworkManager.shared) {
        self.userDefaults = userDefaults
        self.networkManager = networkManager
    }
    
    func fetchOffers() {
        let now = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? Date()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let offersUpdated = userDefaults?.string(forKey: "offersUpdated")
        let data = userDefaults?.data(forKey: "offers")
        if let data = data {
            // Decoding saved offers from userdefaults
           savedOffers = try? JSONDecoder().decode([OfferModel].self, from: data)
        }
        if let offersUpdated = offersUpdated,
           offersUpdated == formatter.string(from: now),
           let savedOffers = savedOffers {
            // Returning saved offers from userdefaults if they were already saved today
            self.offers = savedOffers.map { OfferViewModel(offer: $0) }
            return
        }
        
        networkManager?.fetchOffers(from: formatter.string(from: now), to: formatter.string(from: tomorrow))
            .sink(receiveCompletion: { completion in
                if case .failure(let err) = completion {
                    print("Retrieving data failed with error \(err)")
                }
            }, receiveValue: { responseObject in
                self.handleNetworkResponse(responseObject: responseObject)
            }).store(in: &cancellables)
    }
    
    private func handleNetworkResponse(responseObject: Response?) {
        guard let responseObject = responseObject else { return }
        var fetchedOffers = [OfferModel]()
        if let savedOffers = savedOffers {
            // Returning offers that were not already shown
            for offer in responseObject.data where !savedOffers.contains(offer) {
                fetchedOffers.append(offer)
                if fetchedOffers.count == self.kDailyOffersNumber {
                    break
                }
            }
        } else {
            let limit = min(responseObject.data.count, self.kDailyOffersNumber)
            fetchedOffers = Array(responseObject.data.prefix(upTo: limit))
        }
        
        if let data = try? JSONEncoder().encode(fetchedOffers) {
            // Saving fetched offers to userdefaults
            self.userDefaults?.setValue(data, forKey: "offers")
            self.userDefaults?.setValue(formatter.string(from: Date()), forKey: "offersUpdated")
        }
        
        self.offers = fetchedOffers.map { OfferViewModel(offer: $0) }
    }
    
    func selectOffer(index: Int) {
        selectedOffer = offers[index]
    }
}
