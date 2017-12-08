//
//  MBUserInside.swift
//  TaxiManager
//
//  Created by Joao Paulo on 08/12/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation


// Example of records, "records": [
//{
//    "id": 7,
//    "username": "andre.lira",
//    "firstName": "ANDRE",
//    "lastName": "SOBRENOME",
//    "email": "andre.l@mobint.com.br",
//    "password": "12345",
//    "employeeId": 150,
//    "profileId": 10,
//    "statusId": 1,
//    "firstAccessAt": "2017-11-25T16:12:00.000Z",
//    "lastAccessAt": null,
//    "isBlocked": false,
//    "maxAttempts": 5,
//    "uuidUpdatePassword": "4a9f4d9e-3f39-4ad9-967a-3c3c1fc77df8",
//    "createdUser": "teste",
//    "createdAt": "2017-12-01T15:50:22.000Z",
//    "updatedUser": "andre.lira",
//    "updatedAt": "2017-12-07T21:26:08.000Z"
//}


struct MBUserInside {
    
    var id: Int = 0
    var username : String = ""
    var first_name: String = ""
    var lastName: String = ""
    var email: String = ""
    var emplyeeID : Int = 0
    var profileID : Int = 0
    var statusID : Int = 0
    var firstAccessAt : String = ""
    var isBlocked : Bool = true
    var createdUser : String = ""
    init(from dictionary: [String : Any]){
        
        guard let records = dictionary["records"] as? [[String : Any]] else {return}
        guard let userDict = records.first  else {return}
        
        self.id = userDict["id"] as? Int ?? 0
        self.username = userDict["username"] as? String ?? ""
        self.first_name = userDict[""] as? String ?? ""
        self.lastName = userDict["lastName"] as? String ?? ""
        self.email = userDict["email"] as? String ?? ""
        self.emplyeeID = userDict["employeeId"] as? Int ?? 0
        self.profileID = userDict["profileId"] as? Int ?? 0
        self.statusID = userDict["statusId"] as? Int ?? 0
        self.firstAccessAt = userDict["firstAccessAt"] as? String ?? ""
        self.isBlocked = userDict["isBlocked"] as? Bool ?? true
        self.createdUser = userDict["createdUser"] as? String ?? ""
    }

}
