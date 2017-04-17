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

typealias EmptySuccessHandler = () -> ()
typealias SuccessHandler = (ApiResponse) -> ()
typealias FailHandler = (ApiResponse) -> ()

typealias TeamsSuccessHandler = ([Team]) -> ()
typealias MembershipsSuccessHandler = ([Membership]) -> ()
typealias EventsSuccessHandler = ([Event]) -> ()

class DataHandler {
    static let def = DataHandler()
    
    func getUrl(_ url:String) -> String {
        return "https://dev.coach.plus/api/" + url
    }
    
    func authHeaders() -> HTTPHeaders {
        return [
            "x-access-token":Authentication.getJWT()!
        ]
    }
    
    // Post Helpers
    
    func httpRequest(_ url:String, method: HTTPMethod, params:Parameters, headers:HTTPHeaders?, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest{
        
        let completeUrl = self.getUrl(url)
        
        let encoding:ParameterEncoding
        
        if (method == .get) {
            encoding = URLEncoding.default
        } else {
            encoding = JSONEncoding.default
        }
        
        return Alamofire.request(completeUrl, method: method, parameters: params, encoding: encoding, headers: headers)
            .responseJSON { response in
                
                let val = JSON(response.result.value!)
                
                let apiResponse = ApiResponse(json: val)
                
                if (response.result.isSuccess) {
                    if ((response.response?.statusCode)! >= 400) {
                        failHandler(apiResponse)
                    } else {
                        if (apiResponse.isSuccess()) {
                            successHandler(apiResponse)
                        } else {
                            failHandler(apiResponse)
                        }
                    }
                } else if response.result.isFailure {
                    failHandler(apiResponse)
                }
        }
        
    }
    
    func post(_ url:String, params:Parameters, headers:HTTPHeaders?, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest{
        return self.httpRequest(url, method: .post, params: params, headers: headers, successHandler: successHandler, failHandler: failHandler)
    }
    
    func unauthenticatedPost(_ url:String, params:Parameters, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        return self.post(url, params: params, headers: [:], successHandler: successHandler, failHandler: failHandler)
    }
    
    func authenticatedPost(_ url:String, params:Parameters, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        return self.post(url, params: params, headers: authHeaders(), successHandler: successHandler, failHandler: failHandler)
    }
    
    // Get Helpers
    
    func get(_ url:String, headers:HTTPHeaders?, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest{
        return self.httpRequest(url, method: .get, params: [:], headers: headers, successHandler: successHandler, failHandler: failHandler)
    }
    
    func unauthenticatedGet(_ url:String, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest{
        return self.get(url, headers: [:], successHandler: successHandler, failHandler: failHandler)
    }
    
    func authenticatedGet(_ url:String, headers:HTTPHeaders?, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest{
        return self.get(url, headers: authHeaders(), successHandler: successHandler, failHandler: failHandler)
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
    
    func verifyToken(token:String, successHandler: @escaping EmptySuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "users/verification/" + token
        
        return self.unauthenticatedPost(url, params: [:], successHandler: { apiResponse in
            successHandler()
        }, failHandler: failHandler)
    }
    
    func createTeam(name:String, isPublic:Bool, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "teams/register"
        
        let params:Parameters = [
            "name":name,
            "isPublic":isPublic
        ]
        
        return self.authenticatedPost(url, params: params, successHandler: successHandler, failHandler: failHandler)
        
    }
    
    func getMyTeams(successHandler: @escaping TeamsSuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        let url = "teams/my"
        
        return self.authenticatedGet(url, headers: [:], successHandler: { apiResponse in
            
            let teams = apiResponse.toArray(Team.self, property: "teams")
            successHandler(teams)
            
        }, failHandler: failHandler)
    }
    
    func createInviteLink(teamId:String, validDays:Int?, failHandler: @escaping FailHandler) -> DataRequest {
        var url = "teams/\(teamId)/invite"
        
        if (validDays != nil) {
            url = url + "?validDays=\(validDays!)"
        }
        
        return self.authenticatedPost(url, params: [:], successHandler: { apiResponse in
            
            let inviteResponse = apiResponse.toObject(InviteResponse.self, property: nil)
            print(inviteResponse)
            
        }, failHandler: failHandler)
        
    }
    
    
    func getMyMemberships(successHandler: @escaping MembershipsSuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        let url = "memberships/my"
        
        return self.authenticatedGet(url, headers: [:], successHandler: { apiResponse in
            
            let memberships = apiResponse.toArray(Membership.self, property: "memberships")
            successHandler(memberships)
            
        }, failHandler: failHandler)
    }
    
    func getMembers(teamId:String, successHandler: @escaping MembershipsSuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        let url = "teams/\(teamId)/members"
        
        return self.authenticatedGet(url, headers: [:], successHandler: { apiResponse in
            
            let memberships = apiResponse.toArray(Membership.self, property: "members")
            successHandler(memberships)
            
        }, failHandler: failHandler)
    }
    
    func getEventsOfTeam(team:Team, successHandler: @escaping EventsSuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "teams/\(team.id)/events"
        
        return self.authenticatedGet(url, headers: [:], successHandler: { apiResponse in
            
            let events = apiResponse.toArray(Event.self, property: "events")
            successHandler(events)
            
        }, failHandler: failHandler)
    }
    
    func createEvent(team:Team, createEvent:[String:Any], successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "teams/\(team.id)/events"
        
        return self.authenticatedPost(url, params: createEvent, successHandler: successHandler, failHandler: failHandler)
        
    }
    
}
