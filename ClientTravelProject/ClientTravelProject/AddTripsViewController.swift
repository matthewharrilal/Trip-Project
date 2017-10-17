//
//  AddTripsViewController.swift
//  ClientTravelProject
//
//  Created by Matthew Harrilal on 10/17/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

class AddTripsViewController: UIViewController {
    // UI Elements
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var completedTextField: UITextField!
    
    let networkInstance = UsersNetworkingLayer()
    var passwordText: String?
    var emailText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func addTripButton(_ sender: UIButton) {
        
        let trip = Trips(email: "", completed: true, destination: destinationTextField.text, startDate: startDateTextField.text, endDate: endDateTextField.text, latitude: "", longitude: "", waypointDestination: "")
        
        let user = Users(email: emailText, password: passwordText)
        networkInstance.fetch(route: .trips(), user: user, trip: trip,requestRoute: .postRequest) { (data, responseInt) in
            
            
            
//            let jsonDictionary = ["tripsList": ["trips": ["destination": self.destinationTextField.text, "start_date": self.startDateTextField.text,
//                                                          "end_date": self.endDateTextField.text, "completed": self.completedTextField.text ]]]
//            let serializedDictionary = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
        }
    }
}
