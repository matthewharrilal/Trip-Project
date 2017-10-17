//
//  NetworkingLayer.swift
//  ClientTravelProject
//
//  Created by Matthew Harrilal on 10/12/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit


//Essentially we have to model the code and take the neccesary components from there

let session = URLSession.shared
//var user: Users?

struct BasicAuth {
    static func generateBasicAuthHeader(username: String, password: String) -> String {
        let loginString = String(format: "%@:%@", username, password)
        let loginData: Data = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString(options: .init(rawValue: 0))
        let authHeaderString = "Basic \(base64LoginString)"
        
        return authHeaderString
    }
}



//In this enum we essentially declare the possible routes the user can take
enum Route {
    //    They can either take the users or the trips route
    case users()
    case trips(email: String,password: String)
    
    //    Now that we have declared the possible routes they can take we have to declare the pathways the user can take
    func path() -> String {
        switch self {
        case .users:
            return "/users"
        case .trips:
            return "/trips"
        }
    }
    
    func urlParameters() -> [String: String] {
        switch self {
//        case .users(let email, let password):
//            var userParameters = ["email": String(email),
//                                  "password": "\(password)"]
//            return userParameters
        case .trips(let email, let password):
            let tripsParameters = ["email": String(email),
                                   "password": "\(password)"]
            return tripsParameters
            //            So we have the specific parameters for each of the endpoints
        case .users:
            return ["":""]
        }
        
    }
}


class UsersNetworkingLayer {
    //    We shall be performing our network requests in this class
    
    var baseURL = "http://127.0.0.1:5000"
    
    //    This is the function that determines the path that we are going to be taking the course of
    func fetch(route: Route, user: Users, completionHandler: @escaping (Data, Int) -> Void) {
        let fullUrlString = URL(string: baseURL.appending(route.path()))
        var getRequest = URLRequest(url: fullUrlString!)
        getRequest.httpMethod = "GET"
        getRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        getRequest.addValue((user.credential)!, forHTTPHeaderField: "Authorization")
        session.dataTask(with: getRequest) { (data, response, error) in
            
           let statusCode: Int = (response as! HTTPURLResponse).statusCode
            if let data = data {
                completionHandler(data, statusCode)
               
            }
            
            }.resume()
        
        
    }
    
}

//This is essentially what we call the sanitizing code to be able to implement the parametersrr
extension URL {
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
    // This is formatting the query parameters with an ascii table reference therefore we can be returned a json file
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}


extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

