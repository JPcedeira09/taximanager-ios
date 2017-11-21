//
//  User.swift
//  TaxiManager
//
//  Created by Esdras Martins on 14/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation

struct MBUser : Codable{

    var username : String = ""
    var id : Int = 0
    var email : String = ""
    var token : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var fullName : String = ""
    var companyId : Int = 0
    var employeeId: Int = 0
    
    var pois : [MBPoi]?
    var bookmarks : [MBBookmark]?
    var recents : [MBAddress]?
    
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
        
        
        let company = userDictionary["companyEmployee"] as? [String : Any] ?? [:]
        self.employeeId = company["id"] as? Int ?? 0
        
        self.fullName = company["name"] as? String ?? ""
    
        let companyObj = company["company"] as? [String : Any] ?? [:]
        self.companyId = companyObj["id"] as? Int ?? 0
        MBUser.currentUser = self
    }
    
    static func logout (){
        
        self.currentUser = nil
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
    }
    
    static func update(){
        
        getPois()
        getBookmarks()
        getHistory()
    }
    
    static func getPois(){
        
        print("GET POIS")
        MobiliteeProvider.api.request(.getPOIs) { (result) in
            
            switch result{
                
            case let .success(response):
                
                print("success")
                print(String(data: response.data, encoding: .utf8))
                
                if response.statusCode == 200{
                    print("status 200")
                    do{
                        let mbPois = try response.map([MBPoi].self, atKeyPath: "records")
                        MBUser.currentUser?.pois = mbPois
                        print(mbPois)
                    }catch{
                        
                        print("caiu no catch")
                    }
                }
            case let .failure(error):
                
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    static func getBookmarks(){
        
        print("GET BOOKMARKS")
        
        MobiliteeProvider.api.request(.getBookmarks) { (result) in
            
            switch result{
                
            case let .success(response):
                if response.statusCode == 200{
                    do{
                        
                        print(try response.mapString())
                        let mbBookmarks = try response.map([MBBookmark].self, atKeyPath: "records")
                        
                        MBUser.currentUser?.bookmarks = mbBookmarks
                        
                        print(MBUser.currentUser?.bookmarks)
                    }catch{
                        
                        print("caiu no catch")
                    }
                }
            case let .failure(error):
                
                print(error.localizedDescription)
            }
            
        }
    }
    
    static func getHistory(){
        
        print("GET HISTORY")
        MobiliteeProvider.api.request(.getHistory) { (result) in
            
            switch result{
                
            case let .success(response):
                if response.statusCode == 200{
                    do{
                        print(try response.mapJSON())
//                        let mbPois = try response.map([MBPoi].self, atKeyPath: "records")
//                        MBUser.currentUser?.pois = mbPois
                    }catch{
                        
                        print("caiu no catch")
                    }
                }
            case let .failure(error):
                
                print(error.localizedDescription)
            }
        }
        
    }
}
