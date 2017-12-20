//
//  MBUnauthorizedUser.swift
//  TaxiManager
//
//  Created by Joao Paulo on 20/12/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation


struct MBUnauthorizedUser {

/**
 {
 "developerMessage": "Usuário não encontrado not found",
 "userMessage": "You attempted to get a Usuário não encontrado, but did not find any",
 "errorCode": 20023,
 "moreInfo": "http://www.taximanager.com.br/errors"
 }
 */
    
    var developerMessage:String?
    var userMessage:String?
    var errorCode:Int?
    var moreInfo:String?
    
    init(serializable : [String:Any]){
        
    }
    
    
}
