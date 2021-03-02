//
//  AppDelegate.swift
//  pizzastore
//
//  Created by Carlos Diaz Moreno on 2/2/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let loginVC = LoginViewController(nibName: String(describing: LoginViewController.self), bundle: nil)
        let loginNC = UINavigationController(rootViewController: loginVC)
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)

        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        self.window?.rootViewController = loginNC
        self.window?.makeKeyAndVisible()
        DispatchQueue.main.async {
            if let _ = UserDefaults.standard.value(forKey: "name") {
                let rootVC = PizzaListViewController(nibName: String(describing: PizzaListViewController.self), bundle: nil)
                let rootNC = UINavigationController(rootViewController: rootVC)
                rootNC.modalPresentationStyle = .fullScreen
                loginNC.present(rootNC, animated: false, completion: nil)
            }
        }
        
        return true
    }

}

