//
//  LoginVM.swift
//  CombineDemo
//
//  Created by rahul on 5/13/21.
//

import Foundation
import Combine

final class LoginVM {
    @Published var email = ""
    @Published var password = ""
    
    private(set) lazy var isValidFields = Publishers
        .CombineLatest($email, $password)
        .map { return $0.count > 2 && $1.count > 2 }
        .eraseToAnyPublisher()
    
    let loginResult = PassthroughSubject<Bool, Never>()
        
    func doLogin() {
        // API call 
        self.loginResult.send(true)
    }
}
