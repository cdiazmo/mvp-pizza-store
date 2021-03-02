//
//  PizzaListViewController.swift
//  pizzastore
//
//  Created by Carlos Diaz Moreno on 2/2/21.
//

import UIKit
import Lottie

class ConfirmationViewController: BaseViewController {
    @IBOutlet weak var animationPlaceholder: AnimationView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Confirmación"
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        let animation = Animation.named("pizza-process")
        animationPlaceholder.animation = animation
        animationPlaceholder.loopMode = .loop
        animationPlaceholder.play()
        self.headerTitle.text = "¡Oído cocina!"
        self.descriptionLabel.text = "Tu pedido con referencia #\(UUID().uuidString.suffix(4)) está siendo preparado y se encontrará disponible en breve."
    }
    
    
    @IBAction func continueAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
