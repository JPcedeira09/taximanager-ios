
//
//  Endereco.swift
//  TaxiManager
//
//  Created by Esdras Martins on 14/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation


protocol MBLocation {
    
    //Informacoes basicas
    var latitude : Double {get set}
    var longitude : Double {get set}
    var address : String {get set}
    var district : String {get set}
    var city : String {get set}
    var state : String {get set}
    var zipcode : String {get set}
    
}


//let start = [
//    "lat": -15.762023,
//    "lng": -47.891636,
//    "address":"Rua Augusta - Consolação, São Paulo - SP, Brasil",
//    "district":"Consolação",
//    "city":"São Paulo",
//    "state":"SP",
//    "zipcode":""
//    ] as [String : Any]

