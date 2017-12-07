//
//  MBPlayeyChoose.swift
//  TaxiManager
//
//  Created by Joao Paulo on 07/12/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation

struct MBPlayeyChoose {
    
    /**
 {
 "user_id" : 4,
 "company_id": 3,
 "selected" : 2,
 "type_open" : 2
 } */
    
    /** onde user_id é o id do usuário */
    var user_id : Int = 0
    /** company_id o id da empresa*/
    var company_id : Int = 0
    /** selected é o id do item selecionado */
    var selected: Int = 0
    /** type_open, é 1 para abriu o app, 2 para abriu a loja e 3 para abriu o browser*/
    var type_open: Int = 0

    init(toDict: [String:Any]){
        
    }
}

