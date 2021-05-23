//
//  OfferTableViewCell.swift
//  KiwiApp
//
//  Created by Ivan Milic on 18.5.21..
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var viewModel: OfferViewModel? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        destinationLabel.textColor = .white
        priceLabel.textColor = .white
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        destinationLabel.text = viewModel.flightSummary
        priceLabel.text = viewModel.price
        if let url = viewModel.destinationImageUrl {
            backgroundImageView.load(url: url)
            backgroundImageView.addGradientLayer()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
