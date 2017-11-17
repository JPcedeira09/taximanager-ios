//
//  MBAddress.swift
//  TaxiManager
//
//  Created by Esdras Martins on 14/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation

struct MBAddress : MBLocation, Codable{
    var latitude: Double
    var longitude: Double
    var address: String
    var district: String
    var city: String
    var state: String
    var zipcode: String
    var number: String
    
    enum CodingKeys : String, CodingKey{
        
        case latitude = "lat"
        case longitude = "lng"
        
        case address
        case district
        case city
        case state
        case zipcode
        case number
    }
    
    init(fromLocation location: MBLocation){
        
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.address = location.address
        self.district = location.district
        self.city = location.city
        self.state = location.state
        self.zipcode = location.zipcode
        self.number = location.number
    }
    
    init(latitude: Double, longitude: Double, address: String, district: String, city: String, state: String, zipcode: String, number: String){
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.district = district
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.number = number
        
    }
}
