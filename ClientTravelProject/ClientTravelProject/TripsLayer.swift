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
//    What we are essentially doing here is that we are saying that these are the properties that we want modeled for the data and since we have a non relational database we similarly enforcing a schema
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
//    Here we are essentially initalizing a user therefore ever user will have these implementations 
}

extension Trips: Decodable {
    enum additionalKeys: String, CodingKey {
        case email
        case completed
        case destination
        case startDate = "start_date"
        case endDate = "end_date"
        case latitude = "latitude"
        case longitude = "longitude"
        case waypointDestination = "waypoint_destination"
    }
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: additionalKeys.self)
        let email = try container.decodeIfPresent(String.self, forKey: .email)
        let completed = try container.decodeIfPresent(Bool.self, forKey: .completed)
        let destination = try container.decodeIfPresent(String.self, forKey: .destination)
        let startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        let endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        let latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
        let longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
        let waypointDestination = try container.decodeIfPresent(String.self, forKey: .waypointDestination)
        self.init(email: email, completed: completed, destination: destination, startDate: startDate, endDate: endDate, latitude: latitude, longitude: longitude, waypointDestination: waypointDestination)
    }
}
