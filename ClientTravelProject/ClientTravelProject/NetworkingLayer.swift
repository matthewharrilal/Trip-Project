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
//    What this struct essentially does is that it generates the authentication header when we are sending resources as well as other http methods this essentially serves
// as sanitization code or a helper function

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
    case trips()
    
    //    Now that we have declared the possible routes they can take we have to declare the pathways the user can take
    func path() -> String {
        switch self {
        case .users:
            return "/users"
        case .trips:
            return "/trips"
        }
    }
    
    func urlParameters(destination: String? = nil) -> [String: String] {
        switch self {
        case .trips():
            let tripsParameters = ["destination": String(describing: destination)]
            return tripsParameters
         
        case .users:
            return ["":""]
        }
        
    }
    
    func postBody(user: Users? = nil, trip: Trips? = nil) -> Data? {
        switch self{
        case .trips():
            var jsonBody = Data()
            do {
                jsonBody = try JSONEncoder().encode(trip)
            } catch{}
            return jsonBody
        case .users():
            var jsonBody = Data()
            do {
                jsonBody = try JSONEncoder().encode(user)
            } catch {}
            return jsonBody
        default:
            return nil
        }
    }
    

}

enum differentHttpsMethods: String {
    case getRequest =  "GET"
    case postRequest =   "POST"
    case putRequest =  "PUT"
    case deleteRequest = "DELETE"
}

class UsersNetworkingLayer {
    //    We shall be performing our network requests in this class
    var baseURL = "http://127.0.0.1:5000"
    //    This is the function that determines the path that we are going to be taking the course of
    func fetch(route: Route, user: Users? = nil, trip: Trips? = nil,requestRoute: differentHttpsMethods, completionHandler: @escaping (Data, Int) -> Void) {
        var fullUrlString = URL(string: baseURL.appending(route.path()))
        fullUrlString?.appendingQueryParameters(route.urlParameters())
        var getRequest = URLRequest(url: fullUrlString!)
        getRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        getRequest.addValue((user?.credential)!, forHTTPHeaderField: "Authorization")
        if user != nil {
            getRequest.httpBody = route.postBody(user: user)
        }
        if trip != nil{
            getRequest.httpBody = route.postBody( trip: trip)
        }
        
        getRequest.httpMethod = requestRoute.rawValue
        
        session.dataTask(with: getRequest) { (data, response, error) in
            
            let statusCode: Int = (response as! HTTPURLResponse).statusCode
            if let data = data {
                print(response)
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

