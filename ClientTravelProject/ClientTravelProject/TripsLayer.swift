//
//  TripsLayer.swift
//  ClientTravelProject
//
//  Created by Matthew Harrilal on 10/13/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

struct Trips {
    let email: String?
    let completed: Bool
    let destination:String?
    let startDate: String?
    let endDate: String?
    let latitude: String?
    let longitude: String?
    let waypointDestination: String?
    init(email:String?, completed: Bool, destination: String?, startDate: String?, endDate: String?, latitude: String?, longitude: String?, waypointDestination: String?) {
        self.email = email
        self.completed = completed
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.latitude = latitude
        self.longitude = longitude
        self.waypointDestination = waypointDestination
    }
}
