//
//  UserLayer.swift
//  ClientTravelProject
//
//  Created by Matthew Harrilal on 10/13/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

struct Users {
    let email: String?
    let password: String?
    init(email: String?, password: String?) {
        self.email = email
        self.password = password
    }
}

extension Users: Decodable {
    enum additionalKeys: String, CodingKey {
        case email
        case password
    }
    
//    Now we are going to implement the structure of how the JSON looks and then from there we have to see what we are going to do there
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: additionalKeys.self)
        let email = try container.decodeIfPresent(String.self, forKey: .email)
        let password = try container.decodeIfPresent(String.self, forKey: .password)
        self.init(email: email, password: password)
    }
}

