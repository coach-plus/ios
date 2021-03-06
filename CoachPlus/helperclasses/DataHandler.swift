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
import PromiseKit

class DataHandler {
    static let def = DataHandler()
    
    func getUrl(_ url:String) -> String {
        return "\(Environment.backendURL)api/\(url)"
        //return "http://192.168.222.37:5200/api/" + url
    }
    
    func authHeaders() -> HTTPHeaders {
        return [
            "x-access-token":Authentication.getJWT()!
        ]
    }
    
    // Post Helpers
    
    func httpRequest(_ url:String, method: HTTPMethod, params:Parameters, headers:HTTPHeaders?) -> Promise<ApiResponse>{
        
        let completeUrl = self.getUrl(url)
        
        let encoding:ParameterEncoding
        
        if (method == .get) {
            encoding = URLEncoding.default
        } else {
            encoding = JSONEncoding.default
        }
        
        return Promise { p in
        
            AF.request(completeUrl, method: method, parameters: params, encoding: encoding, headers: headers)
                .responseJSON { response in
                    print(response.data!)
                    print("Request: \(response.request)")
                    print("Response: \(response.response)")
                    print("Error: \(response.error)")
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                    }
                    switch response.result {
                    case .success(let json):
                        
                        switch response.result {
                        case .success(let value):
                            // do nothing
                            break
                        case .failure(let error): break
                            p.reject(ApiError(message: "", statusCode: (response.response?.statusCode)!))
                            return
                        }
                        
                        let val = JSON(response.value!)
                        
                        let apiResponse = ApiResponse(json: val)
                        if ((response.response?.statusCode)! >= 400) {
                            p.reject(ApiError(message: apiResponse.message ?? "", statusCode: (response.response?.statusCode)!))
                        } else {
                            if (apiResponse.isSuccess()) {
                                p.fulfill(apiResponse)
                            } else {
                                p.reject(ApiError(message: "", statusCode: (response.response?.statusCode)!))
                            }
                        }
                    case .failure(let error):
                        p.reject(ApiError(message: L10n.noInternetConnection, statusCode: 0))
                    }
            }
        }
        
    }
    
    func post(_ url:String, params:Parameters, headers:HTTPHeaders?) -> Promise<ApiResponse> {
        return self.httpRequest(url, method: .post, params: params, headers: headers)
    }
    
    func put(_ url:String, params:Parameters, headers:HTTPHeaders?) -> Promise<ApiResponse> {
        return self.httpRequest(url, method: .put, params: params, headers: headers)
    }
    
    func delete(_ url:String, headers:HTTPHeaders?) -> Promise<ApiResponse> {
        return self.httpRequest(url, method: .delete, params: [:], headers: headers)
    }
    
    func unauthenticatedPost(_ url:String, params:Parameters) -> Promise<ApiResponse> {
        return self.post(url, params: params, headers: [:])
    }
    
    func unauthenticatedPut(_ url:String, params:Parameters) -> Promise<ApiResponse> {
        return self.put(url, params: params, headers: [:])
    }
    
    func authenticatedPost(_ url:String, params:Parameters) -> Promise<ApiResponse> {
        return self.post(url, params: params, headers: authHeaders())
    }
    
    func authenticatedPut(_ url:String, params:Parameters) -> Promise<ApiResponse> {
        return self.put(url, params: params, headers: authHeaders())
    }
    
    func authenticatedDelete(_ url:String) -> Promise<ApiResponse> {
        return self.delete(url, headers: authHeaders())
    }
    
    // Get Helpers
    
    func get(_ url:String, headers:HTTPHeaders?) -> Promise<ApiResponse> {
        return self.httpRequest(url, method: .get, params: [:], headers: headers)
    }
    
    func unauthenticatedGet(_ url:String) -> Promise<ApiResponse> {
        return self.get(url, headers: [:])
    }
    
    func authenticatedGet(_ url:String, headers:HTTPHeaders?) -> Promise<ApiResponse>{
        return self.get(url, headers: authHeaders())
    }
    
    
    func register(firstname:String, lastname:String, email:String, password:String, termsAccepted: Bool, dataPrivacyAccepted: Bool) -> Promise<ApiResponse> {
        
        let params: Parameters = [
            "firstname":firstname,
            "lastname":lastname,
            "email":email,
            "password":password,
            User.Fields.termsAccepted.rawValue: termsAccepted,
            User.Fields.dataPrivacyAccepted.rawValue: dataPrivacyAccepted
        ]
        
        return Promise { p in
            self.unauthenticatedPost("users/register", params: params).done { apiResponse in
                let jwtString = apiResponse.content?[0]["token"].stringValue
                if (Authentication.storeJWT(jwt: jwtString!)) {
                    p.fulfill(apiResponse)
                } else {
                    p.reject(ApiError(message: "", statusCode: 999))
                }
            }.catch({ err in
                p.reject(err)
            })
        }
    }
    
    func login(email:String, password:String) -> Promise<ApiResponse> {
        
        let params = [
            "email":email,
            "password":password
        ]
        
        return Promise { p in
            self.unauthenticatedPost("users/login", params: params).done { apiResponse in
                let token = apiResponse.content?[0]["token"].stringValue
                if (Authentication.storeJWT(jwt: token!)) {
                    p.fulfill(apiResponse)
                } else {
                    p.reject(ApiError(message: "", statusCode: 999))
                }
                }.catch({ err in
                    p.reject(err)
                })
        }
    }
    
    func verifyToken(token:String) -> Promise<ApiResponse> {
        
        let url = "users/verification/" + token
        
        return self.unauthenticatedPost(url, params: [:])
    }
    
    func getMyTeams() -> Promise<[Team]> {
        let url = "teams/my"
        
        return self.authenticatedGet(url, headers: [:]).map({ apiResponse in
            return apiResponse.toArray(Team.self, property: "teams")
        })
    }
    
    func createInviteLink(teamId:String, validDays:Int?) -> Promise<InviteResponse> {
        var url = "teams/\(teamId)/invite"
        
        if (validDays != nil) {
            url = url + "?validDays=\(validDays!)"
        }
        
        return self.authenticatedPost(url, params: [:]).map({ apiResponse in
            return apiResponse.toObject(InviteResponse.self, property: nil)
        })
        
    }
    
    
    func getMyMemberships() -> Promise<[Membership]> {
        let url = "memberships/my"
        return self.authenticatedGet(url, headers: [:]).map({ apiResponse in
            let memberships = apiResponse.toArray(Membership.self, property: "memberships")
            MembershipManager.shared.storeMemberships(memberships: memberships)
            return memberships
        })
    }
    
    func getMembershipById(membershipId: String) -> Promise<Membership> {
        let url = "memberships/\(membershipId)"
        return self.authenticatedGet(url, headers: [:]).map({apiResponse in
            let membership = apiResponse.toObject(Membership.self, property: "membership")
            return membership
        })
    }
    
    func getMembers(teamId:String) -> Promise<[Membership]> {
        let url = "teams/\(teamId)/members"
        
        return self.authenticatedGet(url, headers: [:]).map({ apiResponse in
            return apiResponse.toArray(Membership.self, property: "members")
        })
    }
    
    func getMembershipsOfUser(userId:String) -> Promise<[Membership]> {
        let url = "users/\(userId)/memberships"
        
        return self.authenticatedGet(url, headers: [:]).map({ apiResponse in
            let memberships = apiResponse.toArray(Membership.self, property: "memberships")
            return memberships
        })
    }
    
    func getEventsOfTeam(team:Team) -> Promise<[Event]> {
        
        let url = "teams/\(team.id)/events"
        
        return self.authenticatedGet(url, headers: [:]).map({ apiResponse in
            
            let events = apiResponse.toArray(Event.self, property: "events")
            return events
            
        })
    }
    
    func createEvent(team:Team, createEvent:[String:Any]) -> Promise<ApiResponse> {
        
        let url = "teams/\(team.id)/events"
        
        return self.authenticatedPost(url, params: createEvent)
        
    }
    
    func getEvent(teamId: String, eventId: String) -> Promise<Event> {
        let url = "teams/\(teamId)/events/\(eventId)"
        return self.authenticatedGet(url, headers: nil).map({ apiResponse in
            return apiResponse.toObject(Event.self, property: "event")
        })
    }
    
    func updateEvent(teamId: String, eventId: String, updateEvent:[String:Any]) -> Promise<ApiResponse> {
        let url = "teams/\(teamId)/events/\(eventId)"
        return self.authenticatedPut(url, params: updateEvent)
    }
    
    func deleteEvent(event: Event) -> Promise<ApiResponse> {
        let url = "teams/\(event.teamId)/events/\(event.id)"
        return self.authenticatedDelete(url)
    }
    
    func createTeam(createTeam:[String:Any]) -> Promise<Membership> {
        
        let url = "teams/register"
        
        return self.authenticatedPost(url, params: createTeam).map({ apiResponse in
            
            let membership = apiResponse.toObject(Membership.self, property: nil)
            return membership
            
        })
        
    }
    
    func createInviteLink(team:Team, validDays:Int?) -> Promise<String> {
        
        let url = "teams/\(team.id)/invite"
        
        var params = Parameters()
        
        if validDays != nil {
            params["validDays"] = validDays!
        }
        
        return self.authenticatedPost(url, params: params).map({ apiResponse in
            let link = apiResponse.content?[0]["url"].stringValue
            return link ?? ""
        })
        
    }
    
    
    func joinTeam(inviteId:String, teamType: JoinTeamViewController.TeamType) -> Promise<Membership> {
        var url = ""
        
        if (teamType == .publicTeam) {
            url = "teams/public/join/\(inviteId)"
        }
        
        if (teamType == .privateTeam) {
            url = "teams/private/join/\(inviteId)"
        }
        
        return self.authenticatedPost(url, params: [:]).map({ apiResponse in
            let membership = apiResponse.toObject(Membership.self, property: nil)
            return membership
        })
    }
    
    func leaveTeam(teamId: String) -> Promise<ApiResponse> {
        let url = "teams/\(teamId)/memberships"
        
        return self.authenticatedDelete(url)
    }
    
    
    func willAttend(teamId:String, eventId:String, userId:String, willAttend:Bool) -> Promise<ApiResponse> {
        
        let url = "teams/\(teamId)/events/\(eventId)/participation/\(userId)/willAttend"
        
        return self.authenticatedPut(url, params: [
            "willAttend": willAttend ])
    }
    
    
    func didAttend(event:Event, user:User, didAttend:Bool) -> Promise<ApiResponse> {
        
        let url = "teams/\(event.teamId)/events/\(event.id)/participation/\(user.id)/didAttend"
        
        return self.authenticatedPut(url, params:
            ["didAttend": didAttend ])
    }
    
    func getParticipations(event:Event) -> Promise<[ParticipationItem]> {
        
        let url = "teams/\(event.teamId)/events/\(event.id)/participation"
        
        return self.authenticatedGet(url, headers: nil).map({ apiResponse in
            let participations = apiResponse.toArray(ParticipationItem.self, property: "participation")
            return participations
        })
    }
    
    func getNews(event:Event) -> Promise<[News]> {
        
        let url = "teams/\(event.teamId)/events/\(event.id)/news"
        
        return self.authenticatedGet(url, headers: nil).map({ apiResponse in
            let news = apiResponse.toArray(News.self, property: "news")
            return news
        })
    }
    
    func createNews(event:Event, createNews:[String:Any]) -> Promise<ApiResponse> {
        
        let url = "teams/\(event.teamId)/events/\(event.id)/news"
        
        return self.authenticatedPost(url, params: createNews)
    }
    
    
    func deleteNews(teamId:String, news:News) -> Promise<ApiResponse> {
        
        let url = "teams/\(teamId)/events/\(news.eventId)/news/\(news.id)"
        
        return self.authenticatedDelete(url)
    }
    
    func updateUserImage(image:String) -> Promise<User> {
        let url = "users/me/image"
        let params = [
            "image": image
        ]
        return self.authenticatedPut(url, params: params).map({ apiResponse in
            let user = apiResponse.toObject(User.self, property: nil)
            return user
        })
    }
    
    func updateUserInfo(firstname:String, lastname: String, email: String) -> Promise<User> {
        let url = "users/me/information"
        let params = [
            "firstname": firstname,
            "lastname": lastname,
            "email": email
        ]
        return self.authenticatedPut(url, params: params).map({ apiResponse in
            let user = apiResponse.toObject(User.self, property: "user")
            return user
        })
    }
    
    func changePassword(oldPassword:String, newPassword: String, newPasswordRepeat: String) -> Promise<User> {
        let url = "users/me/password"
        let params = [
            "oldPassword": oldPassword,
            "newPassword": newPassword,
            "newPasswordRepeat": newPasswordRepeat
        ]
        return self.authenticatedPut(url, params: params).map({ apiResponse in
            let user = apiResponse.toObject(User.self, property: "user")
            return user
        })
    }
    
    func requestNewPassword(email: String) -> Promise<ApiResponse> {
        let url = "users/password"
        let params = [
            "email": email
        ]
        return self.unauthenticatedPut(url, params: params)
    }
    
    func resendVerificationEmail() -> Promise<ApiResponse> {
        let url = "users/me/verification"
        return self.authenticatedPost(url, params: [:])
    }
    
    func getUser() -> Promise<User> {
        let url = "users/me"
        return self.authenticatedGet(url, headers: nil).map({ apiResponse in
            let user = apiResponse.toObject(User.self, property: "user")
            return user
        })
    }
    
    func updateTeamImage(teamId:String, image:String) -> Promise<Team> {
        let url = "teams/\(teamId)"
        let params = [
            "image": image
        ]
        return self.authenticatedPut(url, params: params).map({ apiResponse in
            let team = apiResponse.toObject(Team.self, property: nil)
            return team
        })
    }
    
    func updateTeam(teamId:String, updatedTeam:[String:Any]) -> Promise<Team> {
        let url = "teams/\(teamId)"
        return self.authenticatedPut(url, params: updatedTeam).map({ apiResponse in
            let team = apiResponse.toObject(Team.self, property: nil)
            return team
        })
    }
    
    func deleteTeam(teamId:String) -> Promise<ApiResponse> {
        let url = "teams/\(teamId)"
        return self.authenticatedDelete(url)
    }
    
    func registerDevice(pushId:String) -> Promise<ApiResponse>? {
        let userId = Authentication.getUser().id
        guard userId != "" else {
            return nil
        }
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let url = "users/\(userId)/devices"
        let params:Parameters = [
            "deviceId": uuid,
            "pushId": pushId,
            "system": "ios"
        ]
        return self.authenticatedPost(url, params: params)
    }
    
    func sendReminder(teamId:String, eventId:String) -> Promise<ApiResponse> {
        
        let url = "teams/\(teamId)/events/\(eventId)/reminder"
        
        return self.authenticatedPost(url, params: [:])
    }
    
    func setRole(membershipId:String, role:String) -> Promise<ApiResponse> {
        let url = "memberships/\(membershipId)/role"
        let payload:Parameters = [
            "role": role
        ]
        return self.authenticatedPut(url, params: payload)
    }
    
    /*
    func getMembership(membershipId: String) -> Promise<Membership> {
        let url = "memberships/\(membershipId)"
        return self.authenticatedGet(url, headers: nil).map({ apiResponse in
            let membership = apiResponse.toObject(Membership.self, property: "membership")
            return membership
        })
    }
     */
    
    func removeUserFromTeam(membershipId: String) -> Promise<ApiResponse> {
        let url = "memberships/\(membershipId)"
        return self.authenticatedDelete(url)
    }
    
}
