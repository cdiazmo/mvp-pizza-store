//
//  LoginPresenter.swift
//  pizzastore
//
//  Created by Carlos Diaz Moreno on 2/2/21.
//

import Foundation

protocol LoginViewPresenter: class {
    func onSigninPressed(name: String, email: String, password: String, status: Bool)
}

protocol LoginDelegate: class {
    func onLoginFailure()
    func onLoginSuccess()
}

class LoginPresenter: LoginViewPresenter {
    
    weak var viewController: LoginViewController?
    weak var delegate: LoginDelegate?
    
    init(_ controller: LoginViewController) {
        viewController = controller
        delegate = controller
    }
    
    func onSigninPressed(name: String, email: String, password: String, status: Bool) {
                
        UserDefaults.standard.setValue(name, forKey: "name");
        UserDefaults.standard.setValue(email, forKey: "email")
        UserDefaults.standard.setValue(status, forKey: "status")
        
        //Login simulation
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            self?.delegate?.onLoginSuccess()
        }
    }
}
