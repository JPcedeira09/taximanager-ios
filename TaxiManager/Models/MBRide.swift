//
//  Travel.swift
//  TaxiManager
//
//  Created by Esdras Martins on 17/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation

struct MBRide : Codable{
    
    var id : Int = 0
    var alertMessage : String?
//    var averagePrice : Float = 0.0
    var waitingTime : Int = 0
    var name : String = ""
    var modality : MBModality
    var price : String = ""
    var urlDeeplink : String?
    var urlLogo : String?
    var urlStore : String?
    var urlWeb : String?
    
    struct MBModality : Codable {
        
        var id : String
        var name : String
        
    }
    
    enum CodingKeys : String, CodingKey{
        
        case id
        case alertMessage = "alert_message"
        case waitingTime = "waiting_time"
        case name
        case price
        case modality
        case urlDeeplink = "url"
        case urlLogo = "url_logo"
        case urlStore = "url_loja_ios"
        case urlWeb = "url_web"
        
    }
}
