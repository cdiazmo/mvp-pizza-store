//
//  File.swift
//  pizzajeff
//
//  Created by Carlos Diaz Moreno on 4/2/21.
//

import UIKit
import Lottie

class OffersViewController: UIViewController {
    
    @IBOutlet weak var offerBackgroundView: UIView!
    @IBOutlet weak var offerTitleLabel: UILabel!
    @IBOutlet weak var offerAnimationView: AnimationView!
    @IBOutlet weak var offerDescription: UILabel!
    @IBOutlet weak var offerImageView: UIImageView!
    
    var presenter: OfferViewPresenter?
    var acceptAction: (() -> Void)?
    var declineAction: (() -> Void)?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, offerObject: AnyObject?, acceptAction: (() -> Void)?, declineAction: (() -> Void)?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.acceptAction = acceptAction
        self.declineAction = declineAction
        presenter = OfferPresenter(self, offer: offerObject)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()
        presenter?.loadView()
    }
    
    @IBAction func offerDeclineAction(_ sender: Any) {
        self.dismiss(animated: false) { [weak self] in
            self?.declineAction?()
        }
    }
    
    @IBAction func offerAcceptAction(_ sender: Any) {
        self.dismiss(animated: false) { [weak self] in
            self?.acceptAction?()
        }
    }
    
}
