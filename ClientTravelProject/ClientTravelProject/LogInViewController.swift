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
    
    let httpResponse = HTTPURLResponse()
    
    let networkingInstance = UsersNetworkingLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInAction(_ sender: Any) {
        //  When the user taps on this button the corresponding the action that is going to result the network request is going to be made to the api representation that we had declared and essentially what happens from there whether the user's log in info is correct the user will be signed in
        networkingInstance.fetch(route: Route.users(email: emailTextField.text!, password: passwordTextField.text!)) { (data) in
//            if self.httpResponse.statusCode == 200 {
//                print("Sorry no entry")
//            }
//            else {
//                print("Okay you are good")
//            }
//
//            }
            print("")
            print("")
            print("")
            print("")
            print(self.httpResponse.statusCode)
            let realDate = Date()
            let date = DateFormatter()
            date1 = date.dateFormat = "hh:mm:ss "
            let appenededDate = "Sun, 15 Oct 2017 \(date1) GMT"
           let dateTime = appenededDate.string(from: realDate)
            print(dateTime)
            if self.httpResponse.statusCode == 200 {
            let users = try? JSONDecoder().decode(Users.self, from: data)
            print(users)
            } else if self.httpResponse.statusCode == 500 {
                print("No entry")
            }
        }
    }
}
