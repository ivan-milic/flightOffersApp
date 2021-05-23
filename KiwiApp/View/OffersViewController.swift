//
//  OffersViewController.swift
//  KiwiApp
//
//  Created by Ivan Milic on 17.5.21..
//

import UIKit
import Combine

class OffersViewController: UIViewController {

    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = OffersViewModel()
    private var cancellables: [AnyCancellable] = []
    
    private let kOfferDetailsSegueId = "showOfferDetails"
    private let kOfferCellId = "offerCell"
    private let kTitle = "Flight offers"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = kTitle
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 150;
        tableView.tableFooterView = UIView()
        
        self.acitivityIndicator.startAnimating()
        
        viewModel.$offers.sink { offers in
            if offers.isEmpty { return }
            DispatchQueue.main.async {
                self.acitivityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.fetchOffers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kOfferDetailsSegueId {
            guard let offerDetailsVC = segue.destination as? OfferDetailsViewController else { return }
            offerDetailsVC.viewModel = viewModel.selectedOffer
        }
    }
}

extension OffersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kOfferCellId, for: indexPath) as? OfferTableViewCell else {
            return UITableViewCell()
        }
        cell.viewModel = viewModel.offers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectOffer(index: indexPath.row)
        performSegue(withIdentifier: kOfferDetailsSegueId, sender: self)
    }
}

