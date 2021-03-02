//
//  PizzaListViewController.swift
//  pizzastore
//
//  Created by Carlos Diaz Moreno on 2/2/21.
//

import UIKit

class PizzaDetailViewController: BaseViewController {
    
    var presenter: DetailViewPresenter?
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var continueButton: RoundedButton!
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, pizzaList: [Pizza]?, pizza: Pizza?, isSingleClient: Bool) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        presenter = DetailPresenter(self, pizzaList: pizzaList, selectedPizza: pizza, isSingleClient: isSingleClient)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()
        presenter?.loadView()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        presenter?.finishOrder()
    }
    
}

