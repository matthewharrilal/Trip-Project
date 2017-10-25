//
// Created by Matthew Harrilal on 10/18/17.
// Copyright (c) 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {
    // So essentially this view controller will serve as our sign up from what the name implies

    //UIElements
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var networkInstance = UsersNetworkingLayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()


    }
    @IBAction func signUpButton(_ sender: Any) {
        let user = Users(email: emailTextField.text, password: passwordTextField.text, username: usernameTextField.text)
        networkInstance.fetch(route: Route.users(), user: user, requestRoute: .postRequest) { (data, responseInt) in
        }
    }
}
