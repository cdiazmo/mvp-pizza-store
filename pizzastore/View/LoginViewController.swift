//
//  LoginViewController.swift
//  pizzastore
//
//  Created by Carlos Diaz Moreno on 2/2/21.
//

import UIKit

class LoginViewController: BaseViewController, LoginDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var signInButton: RoundedButton!
    
    var presenter: LoginViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = LoginPresenter(self)
        self.navigationController?.navigationBar.isHidden = true
        setupUI()
    }
    
    func setupUI() {
        nameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func signInPressedAction(_ sender: Any) {
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            let alert = UIAlertController(title: "Datos incompletos", message: "Datos incompletos, por favor rellene todos los campos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        showLoadingAnnimation()
        presenter?.onSigninPressed(name: name, email: email, password: password, status: statusSegmentedControl.selectedSegmentIndex == 0)
    }
    
    func onLoginFailure() {
        let alert = UIAlertController(title: "Error", message: "Hubo un error al iniciar sesión", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        removeLoadingAnimation()
    }
    
    func onLoginSuccess() {
        removeLoadingAnimation()
        let rootVC = PizzaListViewController(nibName: String(describing: PizzaListViewController.self), bundle: nil)
        let rootNC = UINavigationController(rootViewController: rootVC)
        rootNC.modalPresentationStyle = .fullScreen
        self.present(rootNC, animated: true, completion: { [weak self] in
            self?.nameTextField.text = nil
            self?.passwordTextField.text = nil
            self?.emailTextField.text = nil
            self?.statusSegmentedControl.selectedSegmentIndex = 0
        })
    }
    
    @objc func dismissKeyboard() {
        nameTextField?.resignFirstResponder()
        emailTextField?.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextTextField = textField.superview?.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
