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
typealias MembershipSuccessHandler = (Membership) -> ()
typealias EventsSuccessHandler = ([Event]) -> ()
typealias ParticipationsSuccessHandler = ([ParticipationItem]) -> ()
typealias NewsSuccessHandler = ([News]) -> ()

typealias UserSuccessHandler = (User) -> ()
typealias TeamSuccessHandler = (Team) -> ()

typealias CreateInviteLinkSuccessHandler = (String) -> ()

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
                
                print(response.response?.statusCode)
                
                guard (response.result.value != nil) else {
                    failHandler(ApiResponse(success: false, message: "Unexpected Error", content: nil))
                    return
                }
                
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
    
    func put(_ url:String, params:Parameters, headers:HTTPHeaders?, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest{
        return self.httpRequest(url, method: .put, params: params, headers: headers, successHandler: successHandler, failHandler: failHandler)
    }
    
    func delete(_ url:String, headers:HTTPHeaders?, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest{
        return self.httpRequest(url, method: .delete, params: [:], headers: headers, successHandler: successHandler, failHandler: failHandler)
    }
    
    func unauthenticatedPost(_ url:String, params:Parameters, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        return self.post(url, params: params, headers: [:], successHandler: successHandler, failHandler: failHandler)
    }
    
    func authenticatedPost(_ url:String, params:Parameters, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        return self.post(url, params: params, headers: authHeaders(), successHandler: successHandler, failHandler: failHandler)
    }
    
    func authenticatedPut(_ url:String, params:Parameters, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        return self.put(url, params: params, headers: authHeaders(), successHandler: successHandler, failHandler: failHandler)
    }
    
    func authenticatedDelete(_ url:String, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        return self.delete(url, headers: authHeaders(), successHandler: successHandler, failHandler: failHandler)
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
    
    func createTeam(createTeam:[String:Any], successHandler: @escaping MembershipSuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "teams/register"
        
        return self.authenticatedPost(url, params: createTeam, successHandler: { apiResponse in
            
            let membership = apiResponse.toObject(Membership.self, property: nil)
            successHandler(membership)
            
        }, failHandler: failHandler)
        
    }
    
    func createInviteLink(team:Team, validDays:Int?, successHandler: @escaping CreateInviteLinkSuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "teams/\(team.id)/invite"
        
        var params = Parameters()
        
        if validDays != nil {
            params["validDays"] = validDays!
        }
        
        return self.authenticatedPost(url, params: params, successHandler: { apiResponse in
            
            let link = apiResponse.content?[0]["url"].stringValue
            successHandler(link!)
            
        }, failHandler: failHandler)
        
    }
    
    
    func joinTeam(inviteId:String, teamType:JoinTeamViewController.TeamType, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        var url = ""
        
        if (teamType == .publicTeam) {
            url = "teams/public/join/\(inviteId)"
        }
        
        if (teamType == .privateTeam) {
            url = "teams/private/join/\(inviteId)"
        }
        
        return self.authenticatedPost(url, params: [:], successHandler: successHandler, failHandler: failHandler)
    }
    
    
    func willAttend(event:Event, user:User, willAttend:Bool, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "teams/\(event.teamId)/events/\(event.id)/participation/\(user.id)/willAttend"
        
        return self.authenticatedPut(url, params: [
            "willAttend": willAttend ], successHandler: successHandler, failHandler: failHandler)
    }
    
    
    func didAttend(event:Event, user:User, didAttend:Bool, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "teams/\(event.teamId)/events/\(event.id)/participation/\(user.id)/didAttend"
        
        return self.authenticatedPut(url, params:
            ["didAttend": didAttend ], successHandler: successHandler, failHandler: failHandler)
    }
    
    func getParticipations(event:Event, successHandler: @escaping ParticipationsSuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "teams/\(event.teamId)/events/\(event.id)/participation"
        
        return self.authenticatedGet(url, headers: nil, successHandler: { apiResponse in
            let participations = apiResponse.toArray(ParticipationItem.self, property: "participation")
            successHandler(participations)
        }, failHandler: failHandler)
    }
    
    func getNews(event:Event, successHandler: @escaping NewsSuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "teams/\(event.teamId)/events/\(event.id)/news"
        
        return self.authenticatedGet(url, headers: nil, successHandler: { apiResponse in
            let news = apiResponse.toArray(News.self, property: "news")
            successHandler(news)
        }, failHandler: failHandler)
    }
    
    func createNews(event:Event, createNews:[String:Any], successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "teams/\(event.teamId)/events/\(event.id)/news"
        
        return self.authenticatedPost(url, params: createNews, successHandler: successHandler, failHandler: failHandler)
    }
    
    
    func deleteNews(teamId:String, news:News, successHandler: @escaping SuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        
        let url = "teams/\(teamId)/events/\(news.eventId)/news/\(news.id)"
        
        return self.authenticatedDelete(url, successHandler: successHandler, failHandler: failHandler)
    }
    
    func updateUserImage(image:String, successHandler: @escaping UserSuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        let url = "users/me"
        let params = [
            "image": image
        ]
        return self.authenticatedPut(url, params: params, successHandler: { apiResponse in
            let user = apiResponse.toObject(User.self, property: nil)
            successHandler(user)
        }, failHandler: failHandler)
    }
    
    func updateTeamImage(teamId:String, image:String, successHandler: @escaping TeamSuccessHandler, failHandler: @escaping FailHandler) -> DataRequest {
        let url = "teams/\(teamId)"
        let params = [
            "image": image
        ]
        return self.authenticatedPut(url, params: params, successHandler: { apiResponse in
            let team = apiResponse.toObject(Team.self, property: nil)
            successHandler(team)
        }, failHandler: failHandler)
    }
    
    
    
    
}
