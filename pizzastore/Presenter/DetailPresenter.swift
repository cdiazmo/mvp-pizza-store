//
//  DetailViewPresenter.swift
//  pizzastore
//
//  Created by Carlos Diaz Moreno on 4/2/21.
//


import UIKit

protocol DetailViewPresenter: class {
    func loadView()
    func finishOrder()
}

class DetailPresenter: DetailViewPresenter {
    
    weak var viewController: PizzaDetailViewController?
    var pizza: Pizza?
    var decisionManager: DecisionManager
    
    init(_ controller: PizzaDetailViewController, pizzaList: [Pizza]?, selectedPizza: Pizza?, isSingleClient: Bool) {
        viewController = controller
        self.pizza = selectedPizza
        self.decisionManager = DecisionManager(pizzaList: pizzaList, orderedPizza: pizza, isSingleClient: isSingleClient)
        
    }
    
    func loadView() {
        viewController?.title = pizza?.name
        viewController?.titleLabel.text = pizza?.name
        viewController?.descriptionLabel.text = pizza?.content
        if let imageUrl = pizza?.imageURL {
            loadImage(url: imageUrl)
        }
        initSegmentedControl()
    }
    
    private func initSegmentedControl() {
        var stringArray = Array<String>()
        self.pizza?.prices.forEach({ (price) in
            let option = String(format: "%@ - %.2f€", price.size, price.price)
            stringArray.append(option)
        })
        
        viewController?.segmentedControl.replaceSegments(segments: stringArray)
        viewController?.segmentedControl.selectedSegmentIndex = decisionManager.recommendedPizzaIndex() ?? 0
    }
    
    private func loadImage(url: String){
        NetworkManager.shared.networkRequest(url: url) { (data, error) in
            DispatchQueue.main.async { [weak self] in
                if let data = data, error == nil {
                    self?.viewController?.headerImageView.image = UIImage(data: data)
                } else {
                    self?.viewController?.headerImageView.image = UIImage(named: "default_pizza_image")
                }
            }
        }
    }
    
    private func navigateToConfirmationScreen() {
        let confirmationViewController = ConfirmationViewController(nibName: String(describing: ConfirmationViewController.self), bundle: nil)
        viewController?.navigationController?.pushViewController(confirmationViewController, animated: true)
    }
    
    private func displayOffer (item: AnyObject?){
        DispatchQueue.main.async { [unowned self] in
            let offerViewController = OffersViewController(nibName: String(describing: OffersViewController.self), bundle: nil, offerObject: item, acceptAction: {
                navigateToConfirmationScreen()
            }, declineAction: {
                navigateToConfirmationScreen()
            })
            offerViewController.modalPresentationStyle = .overFullScreen
            self.viewController?.navigationController?.present(offerViewController, animated: false, completion: nil)
        }
    }
    
    var selectedPizzaSize: String? {
        if let position = viewController?.segmentedControl.selectedSegmentIndex {
            return pizza?.prices[position].size
        }
        return nil
    }
    
    func finishOrder() {
        if let selectedSize = selectedPizzaSize {
            viewController?.showLoadingAnnimation()
            decisionManager.run(orderedSize: selectedSize, { offer in
                DispatchQueue.main.async { [weak self] in
                    self?.viewController?.removeLoadingAnimation()
                    if let offer = offer {
                        self?.displayOffer(item: offer)
                    } else {
                        self?.navigateToConfirmationScreen()
                    }
                }
            })
        } else {
            navigateToConfirmationScreen()
        }
    }
    
}

extension UISegmentedControl {
    func replaceSegments(segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}

