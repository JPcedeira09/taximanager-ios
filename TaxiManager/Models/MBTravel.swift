//
//  MBTravel.swift
//  TaxiManager
//
//  Created by Esdras Martins on 23/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation


struct MBTravel : Codable{
    
    var startAddress : String
    var endAddress : String
    var distance : Double
    var cost : Double
    var project : String?
    var player : Player
    var costCentre : CostCentre
    
    
    enum CodingKeys : String, CodingKey{
        
        case startAddress
        case endAddress
        case distance
        case cost
        case project
        case player = "playerService"
        case costCentre = "companyCostCentre"
        
    }
    
    
    struct CostCentre : Codable{
        
        var id : Int
        var name : String
        
    }
    struct Player : Codable {
        
        var id : Int
        var name : String
        var category : Category
        
        enum CodingKeys : String, CodingKey{
            
            case id
            case name = "description"
            case category = "player"
        }
        
        
        struct Category : Codable{
            
            var id : Int
            var name : String
        }
        
        
    }
}



