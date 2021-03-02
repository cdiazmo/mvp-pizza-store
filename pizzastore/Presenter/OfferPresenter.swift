//
//  OfferViewPresenter.swift
//  pizzastore
//
//  Created by Carlos Diaz Moreno on 4/2/21.
//

import UIKit
import Lottie

protocol OfferViewPresenter: class {
    func loadView()
}

class OfferPresenter: OfferViewPresenter {
    
    weak var viewController: OffersViewController?
    var offer: AnyObject?

    init(_ controller: OffersViewController, offer: AnyObject?) {
        viewController = controller
        self.offer = offer
    }
    
    func loadView() {
        viewController?.offerBackgroundView.layer.cornerRadius = 20
        if let movie = offer as? Movie {
            viewController?.offerAnimationView.animation = Animation.named("film-animation")
            viewController?.offerAnimationView.play()
            viewController?.offerAnimationView.loopMode = .loop
            viewController?.offerTitleLabel.text = "Claqueta, pizza, peliculón"
            self.loadImage(url: movie.poster)
            viewController?.offerDescription.text = "Llévate la película \(movie.title) con tu pedido por solo 3.99€ más"
        } else if let pizzaOffer = offer as? PizzaOffer {
            viewController?.offerAnimationView.animation = Animation.named("sale")
            viewController?.offerAnimationView.play()
            viewController?.offerAnimationView.loopMode = .loop
            viewController?.offerTitleLabel.text = "Date un festín"
            self.loadImage(url: pizzaOffer.pizza.imageURL)
            viewController?.offerDescription.text = String(format: "Añade la \(pizzaOffer.pizza.name) con un %.02f%% de descuento a tu pedido, tamaño \(pizzaOffer.size) por solo %.02f€ más", pizzaOffer.discount, pizzaOffer.price)
        }
    }
    
    private func loadImage(url: String) {
        NetworkManager.shared.networkRequest(url: url) { [weak self] (data, error) in
            DispatchQueue.main.async { [unowned self] in
                if let data = data, error == nil {
                    self?.viewController?.offerImageView.image = UIImage(data: data)
                } else {
                    self?.viewController?.offerImageView.image = UIImage(named: "default_pizza_image")
                }
            }
        }
    }
}
