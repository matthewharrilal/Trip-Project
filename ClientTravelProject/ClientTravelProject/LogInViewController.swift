//
//  ViewController.swift
//  ClientTravelProject
//
//  Created by Matthew Harrilal on 10/12/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    //    Our UI Elements
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let networkingInstance = Network()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInAction(_ sender: Any) {

        networkingInstance.fetch(route: Route.users(email: emailTextField.text!, password: passwordTextField.text!)) { (data) in
//            Essentially let us see what the data holds 
            print(data)
            
        }
    }
    
}
