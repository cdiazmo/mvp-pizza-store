//
//  LoadingView.swift
//  pizzajeff
//
//  Created by Carlos Diaz Moreno on 2/2/21.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {
    
    var overlayView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        let backButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        backButton.isAccessibilityElement = true
        backButton.accessibilityIdentifier = "backButton"
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func showLoadingAnnimation() {
        let animationView = AnimationView()
        overlayView?.removeFromSuperview()
        overlayView = UIView()
        overlayView?.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        overlayView?.frame = self.view.frame
        
        let animation = Animation.named("pizza-loading-icon")
        animationView.animation = animation
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.loopMode = .loop
        animationView.play()
        animationView.center = self.view.center
        overlayView?.addSubview(animationView)
        self.view.addSubview(overlayView!)
    }
    
    func removeLoadingAnimation() {
        overlayView?.subviews.forEach({ (view) in
            view.removeFromSuperview()
        })
        overlayView?.removeFromSuperview()
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
