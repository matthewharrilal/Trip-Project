//
//  NetworkingLayer.swift
//  ClientTravelProject
//
//  Created by Matthew Harrilal on 10/12/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

class Singleton {
    //    Essentially what this class will be doing is providing one use of the session therefore we can easily pass this aroundn when we are making network requests
    static let session = URLSession.shared
    private init() {}
    //    Essentially the reason we initalize it so we dont have to instantiate it again
}

//In this enum we essentially declare the possible routes the user can take
enum Route {
    //    They can either take the users or the trips route
    case users(email: String, password: String)
    case trips(email: String)
    
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
        //    This is the function where we essentially declare the parameters the user can be able to implement when making the requests
        
        //    In addition to this we can declare the parameters specifically for each of the endpoint the user chooses
        switch self {
        case .users(let email, let password):
            var userParameters = ["email": String(email),
                                  "password": String(password)]
            return userParameters
        case .trips(let email):
            var tripsParameters = ["email": String(email)]
            return tripsParameters
//            So we have the specific parameters for each of the endpoints
        }
        
    }
    
}

// This is our error handling and this determines whether the user could log in or not
enum NetworkError:Error {
    case unknown
    case couldNotParseJSON
}

enum Result<T> {
    case success(T)
    case failure(NetworkError)
}


class Network {
    //    We shall be performing our network requests in this class
    
    var baseURL = "http://127.0.0.1:5000"
    
//    This is the function that determines the path that we are going to be taking the course of
    func fetch(route: Route, completionHandler: @escaping (Data) -> Void) {
        var fullUrlString = URL(string: baseURL.appending(route.path()))
        fullUrlString?.appendingQueryParameters(route.urlParameters())
        
        var getRequest = URLRequest(url: fullUrlString!)
        getRequest.httpMethod = "GET"
        Singleton.session.dataTask(with: getRequest) { (data, response, errpr) in
            if let data = data {
             completionHandler(data)
            }
            
        }.resume()
        
    }
    
}

//This is essentially what we call the sanitizing code to be able to implement the parameters
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

