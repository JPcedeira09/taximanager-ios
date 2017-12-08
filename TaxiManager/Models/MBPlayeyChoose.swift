//
//  MBPlayeyChoose.swift
//  TaxiManager
//
//  Created by Joao Paulo on 07/12/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation

struct MBPlayeyChoose {
    
    /** JSON example
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
    
    init ( user_id : Int , company_id:Int , selected: Int , type_open: Int){
        self.user_id = user_id
        self.company_id = company_id
        self.selected = selected
        self.type_open = type_open
    }
    
    init(serializable: [String:Any]){
        self.user_id = serializable["user_id"] as? Int ?? 0
        self.company_id = serializable["company_id"] as? Int ?? 0
        self.selected = serializable["selected"] as? Int ?? 0
        self.type_open = serializable["type_open"] as? Int ?? 0
    }
    
    func toDict(_ mbInfoPlayer : MBPlayeyChoose) -> [String: Any]{
        let parametros = ["user_id" :  mbInfoPlayer.user_id, "company_id" :  mbInfoPlayer.company_id, "selected" : mbInfoPlayer.selected, "type_open" : mbInfoPlayer.type_open] as [String : Any]
        return parametros
    }
    
}

