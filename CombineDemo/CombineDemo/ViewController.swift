//
//  ViewController.swift
//  CombineDemo
//
//  Created by rahul on 5/13/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var loginVM = LoginVM()
    var bindings : Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelToViewBinding()
        viewToViewModelBinding()
    }
    
    func viewModelToViewBinding() {
        loginVM.isValidFields
            .receive(on: RunLoop.main)
            .map { $0 ? UIColor.blue : UIColor.lightGray }
            .assign(to: \.backgroundColor, on: loginButton)
            .store(in: &bindings)
        
        loginVM.isValidFields
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &bindings)
        
        loginVM.loginResult.sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(_):
                print("handle error")
            case .finished:
                print("finished")
            }
        }, receiveValue: { (result) in
            if result {
                self.handleSuccess()
            } else {
                self.handleError()
            }
        }).store(in: &bindings)
        
    }
    
    func handleSuccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeVC = storyboard.instantiateViewController(identifier: "WelcomeVC")
        self.present(welcomeVC, animated: true, completion: nil)
    }
    
    func handleError() {
        let alertVC = UIAlertController(title: "login error", message: "oops! something went wrong, please try again!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func viewToViewModelBinding() {
        emailTextfield.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.email, on: loginVM)
            .store(in: &bindings)
        
        passwordTextfield.textPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.password, on: loginVM)
            .store(in: &bindings)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        loginVM.doLogin()
    }
    
}

