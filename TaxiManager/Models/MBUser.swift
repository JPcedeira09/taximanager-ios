//
//  User.swift
//  TaxiManager
//
//  Created by Esdras Martins on 14/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation
import Alamofire

struct MBUser : Codable{
    
    // Users infos.
    var username : String = ""
    var id : Int = 0
    var email : String = ""
    var token : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var fullName : String = ""
    var companyId : Int = 0
    var employeeId: Int = 0
    var firstAccessAt : String?
    
    // POIS & Adress infos.
    var pois : [MBPoi]?
    var bookmarks : [MBBookmark]?
    var recents : [MBAddress]?
    var history : [MBTravel]?
    
    // status employee.
    var statusID: Int = 0
    var statusDescription: String = ""
    static var currentUser : MBUser?
    
    init(from dictionary: [String : Any]){
        
        guard let records = dictionary["records"] as? [[String : Any]] else {return}
        
        guard let userDictionary = records.first  else {return}
        
        self.username = userDictionary["username"] as? String ?? ""
        self.id = userDictionary["id"] as? Int ?? 0
        self.email = userDictionary["email"] as? String ?? ""
        self.token = userDictionary["token"] as? String ?? ""
        self.firstName = userDictionary["firstName"] as? String ?? ""
        self.lastName = userDictionary["lastName"] as? String ?? ""
        self.firstAccessAt = userDictionary["firstAccessAt"] as? String
        
        let company = userDictionary["companyEmployee"] as? [String : Any] ?? [:]
        self.employeeId = company["id"] as? Int ?? 0
        
        self.fullName = company["name"] as? String ?? ""
        
        let companyObj = company["company"] as? [String : Any] ?? [:]
        self.companyId = companyObj["id"] as? Int ?? 0
        
        let statusObj = userDictionary["status"] as? [String:Any] ?? [:]
        self.statusID = statusObj["id"] as? Int ?? 0
        self.statusDescription = statusObj["description"] as? String ?? ""
        
        MBUser.currentUser = self
        
    }
    
    static func logout (){
        self.currentUser = nil
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    static func update(){
        DispatchQueue.global().async {
            getPois()
            getBookmarks()
            getHistory()
        }
    }
    
    static func getPois(){
        MobiliteeProvider.api.request(.getPOIs) { (result) in
            
            switch result{
            case let .success(response):
                if response.statusCode == 200{
                    do{
                        let mbPois = try response.map([MBPoi].self, atKeyPath: "records")
                        MBUser.currentUser?.pois = mbPois
                        print("------------- POIS -------------")
                        print(mbPois)
                        print("------------- POIS -------------")
                    }catch{
                        print("iNFO:caiu no catch getPois")
                        print(error.localizedDescription)
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    static func getBookmarks(){
        let header = ["Content-Type" : "application/json",
                      "Authorization" : MBUser.currentUser?.token ?? ""]
        let url = URL(string: "http://api.taximanager.com.br/v1/taximanager/employees/bookmarks")
        Alamofire.request(
            url!,
            method: .get, headers : header)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let data):
                    // First make sure you got back a dictionary if that's what you expect
                    guard let json = data as? [String : NSObject] else {
                        return
                    }
                    var mbBookmarks  : [MBBookmark] = []
                    let records = json["records"] as! NSArray
                    for item in records {
                        let bookmark = MBBookmark(serializable: item as! [String : Any])
                        print("iNFO BOOKMARK \n :\(bookmark)")
                        mbBookmarks.append(bookmark)
                    }
                    MBUser.currentUser?.bookmarks = mbBookmarks

                case .failure(let error):
                    print(error.localizedDescription)
                    print("iNFO: error in localizedDescription getBookmarks")
                    
                }
        }
    }
    
    /*
     static func getBookmarks(){
     let header = ["Content-Type" : "application/json",
     "Authorization" : MBUser.currentUser?.token ?? ""]
     let url = URL(string: "http://api.taximanager.com.br/v1/taximanager/employees/bookmarks")
     Alamofire.request(
     url!,
     method: .get, headers : header)
     .validate()
     .responseJSON { (response) -> Void in
     switch response.result {
     case .success:
     
     
     do {
     print("------------- MBBookmark RESPONSE -------------")
     print(response)
     print("------------- MBBookmark RESPONSE -------------")
     
     if let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? [[String: Any]]{
     var mbBookmarks  : [MBBookmark]?
     print("------------- MBBookmark dentro if -------------")
     for response in json {
     let bookmark = MBBookmark(serializable: response)
     mbBookmarks.append(bookmark)
     print(bookmark)
     }
     print("------------- MBBookmark set if -------------")
     
     MBUser.currentUser?.bookmarks = mbBookmarks
     }else{
     print("------------- MBBookmark else -------------")
     
     }
     } catch {
     print("iNFO: error in JSONSerialization getBookmarks")
     }
     case .failure(let error):
     print(error.localizedDescription)
     print("iNFO: error in localizedDescription getBookmarks")
     
     }
     
     }
     }
     
     static func getBookmarks(){
     
     MobiliteeProvider.api.request(.getBookmarks) { (result) in
     
     switch result{
     
     case let .success(response):
     if response.statusCode == 200{
     // print("------------- MBBookmark RESPONSE-------------")
     //  print(try? response.mapJSON(failsOnEmptyData: true))
     // print("------------- MBBookmark RESPONSE-------------")
     
     do{
     //let mbBookmarks = try response.map([MBBookmark].self, atKeyPath: "records")
     
     if let json = try JSONSerialization.jsonObject(with: response, options: .allowFragments) as? [[String: Any]]{
     var mbBookmarks  : [MBBookmark] = []
     
     for response in json {
     let bookmark = MBBookmark(serializable: response)
     mbBookmarks.append(bookmark)
     print(bookmark)
     }
     MBUser.currentUser?.bookmarks = mbBookmarks
     print("------------- MBBookmark -------------")
     print(mbBookmarks)
     print("------------- MBBookmark -------------")
     }else { print("nothing")}
     
     }catch{
     print("iNFO:caiu no catch getBookmarks")
     print(error.localizedDescription)
     }
     }
     case let .failure(error):
     print(error.localizedDescription)
     }
     }
     }
     */
    static func getHistory(){
        
        MobiliteeProvider.api.request(.getHistory) { (result) in
            
            switch result{
            case let .success(response):
                if response.statusCode == 200{
                    do{
                        let mbTravels = try response.map([MBTravel].self, atKeyPath: "records")
                        MBUser.currentUser?.history = mbTravels
                        print("------------- MBTravels -------------")
                        print(mbTravels)
                        print("------------- MBTravels -------------")
                    }catch{
                        print("iNFO:caiu no catch getBookmarks")
                        print(error.localizedDescription)
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    //
}
