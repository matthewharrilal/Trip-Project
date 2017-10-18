//
//  DisplayingOfTrips.swift
//  ClientTravelProject
//
//  Created by Matthew Harrilal on 10/15/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

class DisplayTrips: UITableViewController {
    
    var passwordText: String?
    var emailText: String?
    
    let addTripsInstance = AddTripsViewController()
    
    var trips: [Trips] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let networkInstance = UsersNetworkingLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Users(email: emailText, password: passwordText)
        networkInstance.fetch(route: Route.trips(), user: user, requestRoute: .getRequest) { (data, responseInt) in
            let trips0 = try? JSONDecoder().decode([Trips].self, from: data)
            print(trips0)
            
            self.trips = trips0!
            print("The elements in the array are : \(self.trips)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let trips1 = trips[indexPath.row]
        cell.textLabel?.text = trips1.destination
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTrips" {
            let addTripsVC = segue.destination as? AddTripsViewController
            addTripsVC?.emailText = emailText
            addTripsVC?.passwordText = passwordText
        }
    }
    
}
