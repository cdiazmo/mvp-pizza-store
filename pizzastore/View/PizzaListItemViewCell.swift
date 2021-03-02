//
//  PizzaListItemViewCell.swift
//  pizzastore
//
//  Created by Carlos Diaz Moreno on 3/2/21.
//

import UIKit

class PizzaListItemViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tittle: UILabel!
    @IBOutlet weak var priceCaption: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with pizza: Pizza?) {
        self.isAccessibilityElement = true
        self.accessibilityIdentifier = "\(pizza?.id ?? 0)"

        imageView.layer.cornerRadius = 10
        tittle.text = pizza?.name
        if let price = pizza?.prices.first?.price {
            priceCaption.text = String(format: "Desde %.2f€", price)
        } else {
            priceCaption.text = ""
        }
        if let imageUrl = pizza?.imageURL {
            loadImage(url: imageUrl)
        }
    }
    
    
    func loadImage(url: String){
        NetworkManager.shared.networkRequest(url: url) { [weak self] (data, error) in
            DispatchQueue.main.async { [unowned self] in
                if let data = data, error == nil {
                    self?.imageView.image = UIImage(data: data)
                } else {
                    self?.imageView.image = UIImage(named: "default_pizza_image")
                }
            }
        }
    }
}
