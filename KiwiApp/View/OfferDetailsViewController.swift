//
//  OfferDetailsViewController.swift
//  KiwiApp
//
//  Created by Ivan Milic on 19.5.21..
//

import UIKit

class OfferDetailsViewController: UIViewController {

    @IBOutlet weak var destinationImage: UIImageView!
    @IBOutlet weak var flightLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var flightDurationLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var availabilityStackView: UIStackView!
    @IBOutlet weak var availableSeatsLabel: UILabel!
    @IBOutlet weak var stopoversLabel: UILabel!
    
    var viewModel: OfferViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        if let url = viewModel.destinationImageUrl {
            destinationImage.load(url: url)
        }
        flightLabel.text = viewModel.flightSummary
        priceLabel.text = viewModel.price
        departureLabel.text = viewModel.departure
        flightDurationLabel.text = viewModel.flightDuration
        arrivalLabel.text = viewModel.arrival
        availableSeatsLabel.text = viewModel.availableSeats
        if viewModel.availableSeats.isEmpty {
            availabilityStackView.isHidden = true
        }
        stopoversLabel.text = viewModel.stopovers
    }
}
