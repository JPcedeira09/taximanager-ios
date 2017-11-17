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
    
    enum CodingKeys : String, CodingKey{
        
        case latitude = "lat"
        case longitude = "lng"
        
        case address
        case district
        case city
        case state
        case zipcode
    }
}
