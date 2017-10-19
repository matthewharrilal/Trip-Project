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
    
    var networkInstance = UsersNetworkingLayer()
    var passwordText: String?
    var emailText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func addTripButton(_ sender: UIButton) {
        
       let trip = Trips(email: emailText, completed: true, destination: destinationTextField.text, startDate: startDateTextField.text, endDate: endDateTextField.text, waypointDestination: "")
        
        let user = Users(email: emailText, password: passwordText)
        networkInstance.fetch(route: .trips(), user: user, trip: trip,requestRoute: .postRequest) { (data, responseInt) in
            
        }
        //r self.performSegue(withIdentifier: "addedFriends", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "addedFriends" {
//            let displayTripsVC = segue.destination as! DisplayTrips
//            DispatchQueue.main.async {
//                var trips = Trips(email: self.emailText, completed: true, destination: self.destinationTextField.text, startDate: self.startDateTextField.text, endDate: self.endDateTextField.text, waypointDestination: "")
//                trips.destination = self.destinationTextField.text
//                displayTripsVC.trips.append(trips)
//            }
//        }
//    }
 
}
