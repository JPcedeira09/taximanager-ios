//
//  MBBookmark.swift
//  TaxiManager
//
//  Created by Esdras Martins on 16/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation

struct MBBookmark : MBLocation, Codable{
 
    
    /*
     {
     id = 124;
     employeeId = 150;
     mainText = "Polo Botafogo";
     secondaryText = "casa 2";

     latitude = "-23.5816004";
     longitude = "-46.6845959";
     address = "Av. Brg. Faria Lima, S\U00e3o Paulo - SP, Brasil";
     district = "S\U00e3o Paulo";
     city = "S\U00e3o Paulo";
     state = SP;
     zipcode = 00000;
     number = 0;

     createdAt = "2017-12-12T23:59:58.000Z";
     createdUser = "jose.mannis";
     updatedAt = "2017-12-13T03:48:48.000Z";
     updatedUser = "jose.mannis";
     }
     */
    
    //MARK: - Propriedades
    var id : Int?
    var employeeId : Int?
    var mainText : String
    var secondaryText : String
    
    //MARK: - MBLocation
    var latitude: Double
    var longitude: Double
    var address: String
    var district: String
    var city: String
    var state: String
    var zipcode: String
    var number: String
    
    var createdAt : String
    var createdUser : String
    var updatedAt : String
    var updatedUser : String
    
    
    init(withLocation location : MBLocation, mainText : String, secondaryText : String, createdAt : String, createdUser : String, updatedAt : String, updatedUser: String){
        
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.address = location.address
        self.district = location.district
        self.city = location.city
        self.state = location.state
        self.zipcode = location.zipcode
        self.number = location.number
        
        self.mainText = mainText
        self.secondaryText = secondaryText
        
        self.createdAt = createdAt
        self.createdUser = createdUser
        self.updatedAt = updatedAt
        self.updatedUser = updatedUser
    }
    
    init(serializable: [String:Any]){
        
    self.latitude = serializable["latitude"] as? Double ?? 0.0
    self.longitude = serializable["longitude"] as? Double ?? 0.0
    self.address = serializable["address"] as? String ?? ""
    self.district = serializable["district"] as? String ?? ""
    self.city = serializable["city"] as? String ?? ""
    self.state = serializable["state"] as? String ?? ""
    self.zipcode = serializable["zipcode"] as? String ?? ""
    self.number = serializable["number"] as? String ?? ""
    
    self.mainText = serializable["mainText"] as? String ?? ""
    self.secondaryText = serializable["secondaryText"] as? String ?? ""
    
    self.createdAt = serializable["createdAt"] as? String ?? ""
    self.createdUser = serializable["createdUser"] as? String ?? ""
    self.updatedAt = serializable["updatedAt"] as? String ?? ""
    self.updatedUser = ""
    
    }
    
}
