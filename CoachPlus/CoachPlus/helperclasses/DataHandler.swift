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

typealias SuccessHandler = (ApiResponse) -> ()
typealias FailHandler = (ApiResponse) -> ()

class DataHandler {
    static let def = DataHandler()
    
    func getUrl(_ url:String) -> String {
        return "https://dev.coach.plus/api/" + url
    }
    
    func post(_ url:String, params:Parameters, headers:HTTPHeaders?, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest{
        
        let completeUrl = self.getUrl(url)
        
        return Alamofire.request(completeUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                
                let val = JSON(response.result.value!)
                
                let apiResponse = ApiResponse(json: val)
                
                if (response.result.isSuccess) {
                    if ((response.response?.statusCode)! >= 400) {
                        failHandler(apiResponse)
                    } else {
                        successHandler(apiResponse)
                    }
                } else if response.result.isFailure {
                    failHandler(apiResponse)
                }
        }
        
    }
    
    func unauthenticatedPost(_ url:String, params:Parameters, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        return self.post(url, params: params, headers: nil, successHandler: successHandler, failHandler: failHandler)
    }
    
    func authenticatedPost(_ url:String, params:Parameters, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let headers: HTTPHeaders = [
            "x-access-token":Authentication.getJWT()!
        ]
        
        return self.post(url, params: params, headers: headers, successHandler: successHandler, failHandler: failHandler)
    }
    
    
    func register(firstname:String, lastname:String, email:String, password:String, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let params = [
            "firstname":firstname,
            "lastname":lastname,
            "email":email,
            "password":password
        ]
        
        return self.unauthenticatedPost("users/register", params: params, successHandler: { apiResponse in
            
            let jwtString = apiResponse.content?[0]["token"].stringValue
            if (Authentication.storeJWT(jwt: jwtString!)) {
                successHandler(apiResponse)
            } else {
                failHandler(apiResponse)
            }
            
        }, failHandler: failHandler)
    }
    
    func login(email:String, password:String, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let params = [
            "email":email,
            "password":password
        ]
        
        return self.unauthenticatedPost("users/login", params: params, successHandler: { apiResponse in
            
            let token = apiResponse.content?[0]["token"].stringValue
            
            if (Authentication.storeJWT(jwt: token!)) {
                successHandler(apiResponse)
            } else {
                failHandler(apiResponse)
            }
            
        }, failHandler: failHandler)
    }
    
    func verifyToken(token:String, successHandler: @escaping () -> (), failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "users/verification/" + token
        
        return self.unauthenticatedPost(url, params: [:], successHandler: { apiResponse in
            
            if (apiResponse.success) {
                successHandler()
            } else {
                failHandler(apiResponse)
            }
            
            
        }, failHandler: failHandler)
        
        
    }
    
}
