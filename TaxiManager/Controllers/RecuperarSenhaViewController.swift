//
//  RecuperarSenhaViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 14/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit

class RecuperarSenhaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let start = [
        //    "lat": -15.762023,
        //    "lng": -47.891636,
        //    "address":"Rua Augusta - Consolação, São Paulo - SP, Brasil",
        //    "district":"Consolação",
        //    "city":"São Paulo",
        //    "state":"SP",
        //    "zipcode":""
        //    ] as [String : Any]
        
//        "end": {
//            "lat": -15.834928,
//            "lng": -47.912829,
//            "address": "Rua Pamplona - Jardim Paulista, São Paulo - SP, Brasil",
//            "district": "",
//            "city": "São Paulo",
//            "state": "SP",
//            "zipcode": ""
//        },


//
//        let start = MBAddress(latitude: -15.762023, longitude: -47.891636, address: "Rua Augusta - Consolação, São Paulo - SP, Brasil", district: "Consolação", city: "São Paulo", state: "SP", zipcode: "")
//
//        let end = MBAddress(latitude: -15.834928, longitude: -47.912829, address: "Rua Pamplona - Jardim Paulista, São Paulo - SP, Brasil", district: "", city: "São Paulo", state: "SP", zipcode: "")
//
//
//
//        MobiliteeAPI.api.request(.estimate(start: start, end: end, device: MBDevice(), distance: 3200, duration: 11, userId: 139, companyId: 3 )) { (result) in
//
//            print(result.error?.localizedDescription)
//            print(result.value)
//        }
    }
    
    

    @IBAction func recuperarSenha(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
}
