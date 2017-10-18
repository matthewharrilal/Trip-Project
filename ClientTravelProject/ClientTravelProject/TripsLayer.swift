//
//  TripsLayer.swift
//  ClientTravelProject
//
//  Created by Matthew Harrilal on 10/13/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

var user: Users?

struct Trips: Codable {
    //    What we are essentially doing here is that we are saying that these are the properties that we want modeled for the data and since we have a non relational database we similarly enforcing a schema
    
    
    let email: String?
    let completed: Bool?
    let destination:String?
    let startDate: String?
    let endDate: String?
    let waypointDestination: String?
    init(email:String?, completed: Bool?, destination: String?, startDate: String?, endDate: String?, waypointDestination: String?) {
        self.email = email
        self.completed = completed
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.waypointDestination = waypointDestination
    }
    //    Here we are essentially initalizing a user therefore ever user will have these implementations
}

extension Trips {
    enum firstLayerKeys: String, CodingKey {
        case email
        case completed
        case destination
        case startDate = "start_date"
        case endDate = "end_date"
        case waypointDestination = "waypoint_destination"
    }
  
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: firstLayerKeys.self)
        let email = try container.decodeIfPresent(String.self, forKey: .email)
        let completed = try container.decodeIfPresent(Bool.self, forKey: .completed)
        let destination = try container.decodeIfPresent(String.self, forKey: .destination)
        let startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        let endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        let waypointDestination = try container.decodeIfPresent(String.self, forKey: .waypointDestination)
        self.init(email: email, completed: completed, destination: destination, startDate: startDate, endDate: endDate, waypointDestination: waypointDestination)
    }
}
