//
//  MBBookmark.swift
//  TaxiManager
//
//  Created by Esdras Martins on 16/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation

struct MBBookmark : MBLocation, Codable{
 
    //MARK: - MBLocation
    var latitude: Double
    var longitude: Double
    var address: String
    var district: String
    var city: String
    var state: String
    var zipcode: String
    var number: String
    
    //MARK: - Propriedades
    
    var id : Int?
    var employeeId : Int?
    var mainText : String
    var secondaryText : String
    
//    enum CodingKeys : String, CodingKey{
//        
//        case latitude = "lat"
//        case longitude = "lng"
//        
//        case address
//        case district
//        case city
//        case state
//        case zipcode
//        case number
//        
//        case id
//        case employeeId
//        case mainText
//        case secondaryText
//    }
    
    init(withLocation location : MBLocation, mainText : String, secondaryText : String){
        
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
        
    }
    
}
