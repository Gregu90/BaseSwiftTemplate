//
//  APIClient.swift
//  BaseProject
//
//  Created by Admin on 10.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import ObjectMapper

private let _SharedInstance = APIClient()

class APIClient : RESTClient
{
    class var sharedClient: APIClient
    {
        return _SharedInstance
    }
    
    override init()
    {
        super.init()
        self.setup("apiBaseURLString")
    }
        
    //MARK: - Requests
    
//    func doRequest(completion: ((_ success: Bool, _ error: Error?)->())?)
//    {
//        self.makeRequest(method: .get, path: APIConstants.Paths.Cities.string) {
//            (request, response, statusCode, error) in
//            guard let completion = completion else { return }
//
//            if let error = error {
//                completion(false, error)
//            }else{
//                completion(true, nil)
//            }
//        }
//    }
    
}

