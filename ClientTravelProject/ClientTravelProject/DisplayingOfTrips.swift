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
//        networkInstance.fetch(route: Route.trips(email: "coreyharrilal@gmail.com")) { (data, responseInt) in
//                let trips0 = try? JSONDecoder().decode(ArrayTrips.self, from: data)
//                print(trips0)
//                guard let trips1 = trips0?.trips else{return}
//                 self.trips = trips1
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//        }
        networkInstance.fetch(route: Route.trips(email: emailText!, password: passwordText!)) { (data, responseInt) in
            let trips0 = try? JSONDecoder().decode(ArrayTrips.self, from: data)
            print(trips0)
            guard let trips1 = trips0?.tripsList else{return}
            self.trips = trips1
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
        cell.detailTextLabel?.text = String(describing: trips1.completed)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
}
