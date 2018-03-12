//
//  GooglePlacesAPI.swift
//  GetGoing
//
//  Created by Carlo Carandang on 2018-03-10.
//  Copyright © 2018 Carlo Carandang. All rights reserved.
//

import Foundation

class GooglePlacesAPI {
    
    class func requestPlaces(query: String?, completion: @escaping (_ status: Int, _ errorMessage: String?, _ json:[String: Any]?) -> Void){
    
        
        var urlComponents = URLComponents()
        urlComponents.host = Constants.host
        urlComponents.scheme = Constants.scheme
        urlComponents.path = Constants.textPlaceSearch
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "key", value: Constants.apiKey)
        ]
        
        if let url = urlComponents.url {
            let request = NSMutableURLRequest(url: url)
            
            let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if error != nil {
                    completion(500, "unknown error", nil)
                    
                } else {
                    if let responseData = data, let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        completion(200, nil, json)
                        
                    } else {
                        completion(500, "unknown error", nil)
                        return
                    }
                }
            })
            dataTask.resume()
        }
    }
}
