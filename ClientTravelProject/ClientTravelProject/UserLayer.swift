//
//  UserLayer.swift
//  ClientTravelProject
//
//  Created by Matthew Harrilal on 10/13/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

struct Users: Codable {
    let email: String?
    let password: String?
    let username: String?
    let credential: String?
    init(email: String?, password: String?, username: String?) {
        self.email = email
        self.password = password
        self.username = username
        self.credential = BasicAuth.generateBasicAuthHeader(username: self.email!, password: self.password!)
    }
}

extension Users {
    enum additionalKeys: String, CodingKey {
        case email
        case password
        case username
    }
    
//    Now we are going to implement the structure of how the JSON looks and then from there we have to see what we are going to do there
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: additionalKeys.self)
        let email = try container.decodeIfPresent(String.self, forKey: .email)
        let password = try container.decodeIfPresent(String.self, forKey: .password) ?? "No password"
        let username = try container.decodeIfPresent(String.self, forKey: .username)
        self.init(email: email, password: password, username: username)
    }
}

