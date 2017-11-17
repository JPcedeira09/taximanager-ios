//
//  MBPoi.swift
//  TaxiManager
//
//  Created by Esdras Martins on 16/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation

struct MBPoi : MBLocation, Codable{
    
    //MARK: - MBLocation
    var latitude: Double
    var longitude: Double
    var address: String
    var district: String
    var city: String
    var state: String
    var zipcode: String
    
    //MARK: - propriedades
    
    var id : Int
    var companyId: Int
    var mainText: String
    var secondaryText : String
    
}
