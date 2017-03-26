//
//  DataHandler.swift
//  CoachPlus
//
//  Created by Breit, Maurice on 26.03.17.
//  Copyright © 2017 Mathandoro GbR. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataHandler {
    static let def = DataHandler()
    
    func getUrl(_ url:String) -> String {
        return "https://dev.coach.plus/api/" + url
    }
    
    func post(_ url:String, params:Parameters, headers:HTTPHeaders?, successHandler: @escaping (JSON) -> (), failHandler: @escaping (String?) -> ()) -> DataRequest{
        
        let completeUrl = self.getUrl(url)
        
        return Alamofire.request(completeUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                let val = JSON(response.result.value!)
                
                if (response.result.isSuccess) {
                    if ((response.response?.statusCode)! >= 400) {
                        failHandler(val["error"].string)
                    } else {
                        successHandler(val)
                    }
                } else if response.result.isFailure {
                    failHandler(val["error"].string)
                }
        }
        
    }
    
    func unauthenticatedPost(_ url:String, params:Parameters, successHandler: @escaping (JSON) -> (), failHandler: @escaping (String?) -> ()) -> DataRequest {
        return self.post(url, params: params, headers: nil, successHandler: successHandler, failHandler: failHandler)
    }
    
    func authenticatedPost(_ url:String, params:Parameters, successHandler: @escaping (JSON) -> (), failHandler: @escaping (String?) -> ()) -> DataRequest {
        
        let headers: HTTPHeaders = [
            "x-access-token":Authentication.getJWT()!
        ]
        
        return self.post(url, params: params, headers: headers, successHandler: successHandler, failHandler: failHandler)
    }
    
    
    func register(firstname:String, lastname:String, email:String, password:String, successHandler: @escaping () -> (), failHandler: @escaping (_ msg:String?) -> ()) -> DataRequest {
        
        let params = [
            "firstname":firstname,
            "lastname":lastname,
            "email":email,
            "password":password
        ]
        
        return self.unauthenticatedPost("users/register", params: params, successHandler: { json in
            
            let jwtString = json["token"].stringValue
            if (Authentication.storeJWT(jwt: jwtString)) {
                successHandler()
            } else {
                failHandler("Internal Error")
            }
            
        }, failHandler: failHandler)
    }
    
    func login(email:String, password:String, successHandler: @escaping () -> (), failHandler: @escaping (_ msg:String?) -> ()) -> DataRequest {
        
        let params = [
            "email":email,
            "password":password
        ]
        
        return self.unauthenticatedPost("users/login", params: params, successHandler: { json in
            
            print(json)
            
            let token = json["token"].stringValue
            
            if (Authentication.storeJWT(jwt: token)) {
                successHandler()
            } else {
                failHandler("Internal Error")
            }
            
        }, failHandler: failHandler)
        
        
    }
    
}
