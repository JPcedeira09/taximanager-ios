//
//  MobiliteeEstimate.swift
//  TaxiManager
//
//  Created by Esdras Martins on 14/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation
import Moya

enum MobiliteeProvider {
    
    //MARK: - Methods
    case estimate(start : MBLocation, end : MBLocation, distance : Int, duration : Int, userId : Int, companyId: Int)
    case login(username: String, password: String)
    case getPOIs
    case getBookmarks
    case postBookmark(bookmark : MBBookmark)
    case deleteBookmark(bookmarkId : Int)
    case getHistory
    case patchUser(userId : Int, newPassword : String)
    case recoveryPassword(username : String)
    
    static let api = MoyaProvider<MobiliteeProvider>()
}

extension MobiliteeProvider : TargetType{
    var sampleData: Data {
        switch(self){
            
        case .estimate:
            // Provided you have a file named accounts.json in your bundle.
            guard let url = Bundle.main.url(forResource: "estimateSampleData", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
            

        default :
            return Data()
            
        }
        
    }
    
    var task: Task {
        
        switch(self){
            
        case let .estimate(start, end, distance, duration, userId, companyId):
            
            do{
                
                let start = try MBAddress(fromLocation: start).asDictionary()
                let end = try MBAddress(fromLocation: end).asDictionary()
                let device = try MBDevice().asDictionary()
                
                let parameters = ["start" : start,
                                  "end" : end,
                                  "device" : device,
                                  "distance" : distance,
                                  "duration" : duration,
                                  "user_id": userId,
                                  "company_id": companyId] as [String : Any]
    
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
                
            }catch{
                return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
            }
        
        
        case let .postBookmark(bookmark):
            do{
                let parameters = try bookmark.asDictionary()
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
                
            }catch{
                return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
            }
            
        case let .patchUser(userId, newPassword):
            
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.timeZone = TimeZone(identifier: "America/Sao_Paulo")
            print(formatter.string(from: now))
            
            
            let parameters = [
                "id": userId,
                "password": newPassword,
                "firstAccessAt": formatter.string(from: now),
            ] as [String : Any]
            
            print("00000000 PARAMETROS 0000000")
            print(parameters)
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        
        case let .recoveryPassword(username):
        
            let parameters = ["username" : username]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .getHistory:
            
            let parameters = ["employeeId" : MBUser.currentUser!.employeeId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
        
    }
    
    var baseURL: URL {
        
        switch (self) {
        case .estimate:
            
            return URL(string: "https://estimate.taximanager.com.br/v1")!
        default:
            return URL(string: "https://api.taximanager.com.br/v1/taximanager")!
//            return URL(string: "http://ec2-54-207-58-85.sa-east-1.compute.amazonaws.com/v1/taximanager")!
        }
    }
    
    var path: String {
        
        switch(self){
            
        case .estimate :
            return "/estimates"
        case .login:
            return "/users/login"
        case .getPOIs:
            return "/companies/interestpoints"
        case .getBookmarks, .postBookmark:
            return "/employees/bookmarks"
        case let .deleteBookmark(bookmarkId):
            return "/employees/bookmarks/\(bookmarkId)"
        case .getHistory:
            return "/companies/\(MBUser.currentUser?.companyId ?? 0)/travels"
        case .patchUser:
            return "/users"
        case .recoveryPassword:
            return "/users/password/recovery"
            
        }
    }
    
    var method: Moya.Method {
        
        switch(self){
            
        case .estimate, .postBookmark:
            return .post
        case .deleteBookmark:
            return .delete
        case .patchUser:
            return .patch
        default:
            return .get
        }
    }

    var headers: [String : String]? {
        
        switch(self){

        case let .login(usuario, senha):
            
            let token = (usuario + ":" + senha).toBase64()
            
            return ["Authorization" : "Basic :" + token]

        default:

            return ["Content-Type" : "application/json",
                    "Authorization" : MBUser.currentUser?.token ?? ""]
        }
    }
}
