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
import RealmSwift

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

    // MARK: - Recommendations API
    static func shouldRefetchRecommendations() -> Bool {
        let defaultsKey = "refetchMetadata"
        let defaults = UserDefaults.standard
        let refetchMetadata = defaults.object(forKey: defaultsKey) as! Dictionary<String, Dictionary<String, Any>>

        return (refetchMetadata["recommendations"]!["shouldRefetch"] as? Bool)!
    }
    
    static func resetRecommendationsRefetchMetadata() -> Void {
        let defaultsKey = "refetchMetadata"
        let defaults = UserDefaults.standard
        var refetchMetadata = defaults.object(forKey: defaultsKey) as! Dictionary<String, Dictionary<String, Any>>

        refetchMetadata["recommendations"] = ["shouldRefetch": false, "refetchedAt": NSDate()]
        defaults.set(refetchMetadata, forKey: defaultsKey)
    }
    
    static func storeFetchedRecommendations(data: JSON, completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        let realm = try! Realm()
        print("Storing fetched recommendations")
        do {
            try realm.write {
                for recommendation in data["data"].arrayValue {
                    let newRecommendation = Recommendation()
                    newRecommendation.yelpId = recommendation["id"].stringValue
                    newRecommendation.name = recommendation["name"].stringValue
                    newRecommendation.imageUrl = recommendation["image_url"].stringValue
                    newRecommendation.isClosed = recommendation["is_closed"].boolValue
                    newRecommendation.location = (recommendation["location"]["display_address"].arrayObject! as! [String]).joined(separator: " ")
                    newRecommendation.price = recommendation["price"].stringValue
                    newRecommendation.url = recommendation["url"].stringValue

                    realm.add(newRecommendation)
                }
            }
        } catch {
            print("Error storing fetched recommendations.")
        }
        
        let recommendations = realm.objects(Recommendation.self)

        print(recommendations)
    }
    
    func getRecommendations(withPage page: Int, completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        if ScoutRequest.shouldRefetchRecommendations() {
            self.compose(authenticated: true,
                         path: "/recommendations",
                         method: .get,
                         params: [:]) { (error, data) in
                            if error == nil {
                                ScoutRequest.storeFetchedRecommendations(data: data!, completion: completion)
                            } else {
                                completion(error, nil)
                            }
            }
        } else {

        }
    }
    
    // MARK: - Visits API
    static func shouldRefetchVisits() -> Bool {
        let defualtsKey = "refetchMetadata"
        let defaults = UserDefaults.standard
        let refetchMetadata = defaults.object(forKey: defualtsKey) as! Dictionary<String, Dictionary<String, Any>>
        
        return (refetchMetadata["visits"]!["shouldRefetch"] as? Bool)!
    }
    
    static func resetVisitsRefetchMetadata() -> Void {
        let defaultsKey = "refetchMetadata"
        let defaults = UserDefaults.standard
        var refetchMetadata = defaults.object(forKey: defaultsKey) as! Dictionary<String, Dictionary<String, Any>>
        
        refetchMetadata["visits"] = ["shouldRefetch": false, "refetchedAt": NSDate()]
        defaults.set(refetchMetadata, forKey: defaultsKey)
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

    
    func getPlacesToDiscover(withCoords coords: Dictionary<String, Double>, completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        self.compose(authenticated: true,
                     path: "/discover",
                     method: .get,
                     params: coords,
                     encoding: URLEncoding(destination: .queryString),
                     completion: completion)
    }
    
    func getVisits(withPage page: Int, completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        self.compose(authenticated: true,
                     path: "/visits",
                     method: .get,
                     params: ["page": page],
                     encoding: URLEncoding(destination: .queryString),
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

    func compose(authenticated: Bool, path: String, method: HTTPMethod, params: Parameters, encoding: URLEncoding? = nil, completion: @escaping (_ error: Error?, _ data: JSON?) -> Void) -> Void {
        let headers: [String:String] = authenticated ? ["Authorization": "Bearer \(ScoutRequest.getJWT())"] : [:]

        Alamofire.request(self.base_url + path,method: method,
                          parameters: params,
                          encoding: encoding ?? JSONEncoding.default,
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


