//
//  ScoutRequest.swift
//  app.scout.io
//
//  Created by Jesus Marco Del Carmen on 5/10/18.
//  Copyright © 2018 Jesus Marco Del Carmen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KeychainAccess

class ScoutRequest {
    let base_url: String = Bundle.main.infoDictionary!["base_url"] as! String
    
    static func storeJWT(_ token: String) -> Void {
        let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
        keychain["token"] = token
    }
    
    static func getJWT() -> String {
        do {
            return try Keychain(service: Bundle.main.bundleIdentifier!).get("token")!
        } catch {
            return ""
        }
    }

    func login(withUsernameOrEmail usernameOrEmail: String, password: String, completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        self.compose(authenticated: false,
                     path: "/auth/login",
                     method: .post,
                     params: ["username_or_email": usernameOrEmail, "password": password],
                     completion: completion)
    }
    
    func signup(username: String, email: String, password: String, completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        self.compose(authenticated: false,
                     path: "/auth/signup",
                     method: .post,
                     params: ["username": username, "email": email, "password": password],
                     completion: completion)
    }
    
    func getRecommendations(withPage page: Int, completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        self.compose(authenticated: true,
                     path: "/recommendations",
                     method: .get,
                     params: ["page": page],
                     completion: completion)
    }
    
    func getVisits(completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        self.compose(authenticated: true,
                     path: "/visits",
                     method: .get,
                     params: [:],
                     completion: completion)
    }
    
    func createVisit(withYelpId yelpId: String, attendDate: String, satisfaction: Int, completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        self.compose(authenticated: true,
                     path: "/visits",
                     method: .post,
                     params: ["yelp_id": yelpId, "attend_date": attendDate, "satisfaction": satisfaction],
                     completion: completion)
    }
    
    func searchBusinesses(withTermAndLocation q: String, location: String, completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        self.compose(authenticated: true,
                     path: "/search",
                     method: .post,
                     params: ["q": q, "location": location],
                     completion: completion)
    }

    func compose(authenticated: Bool, path: String, method: HTTPMethod, params: Parameters, completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        let headers: [String:String] = authenticated ? ["Authorization": "Bearer \(ScoutRequest.getJWT())"] : [:]

        Alamofire.request(self.base_url + path,method: method,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .validate(statusCode: 200..<300).responseJSON { (response: DataResponse) in
                switch response.result {
                case .success:
                    completion(nil, JSON(response.data!))
                case .failure(let error):
                    let statusCode = response.response?.statusCode

                    if (statusCode == 401) {
                        NotificationCenter.default.post(name: NSNotification.Name("UnAuthenticated"), object: nil)
                    }
                    completion(error, nil)
                }
        }
    }
}


