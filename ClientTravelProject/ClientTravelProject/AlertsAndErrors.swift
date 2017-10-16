//
// Created by Matthew Harrilal on 10/15/17.
// Copyright (c) 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

struct Alerts {
    func logInError( controller: UIViewController) {
        let logInAlert = UIAlertController(title: "Invalid Credentials", message: " Please try logging in again", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        logInAlert.addAction(cancelAction)
        controller.present(logInAlert, animated: true, completion: nil)
    }
}