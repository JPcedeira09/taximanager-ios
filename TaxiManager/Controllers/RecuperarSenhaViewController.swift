//
//  RecuperarSenhaViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 14/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import TextFieldEffects
import SwiftSpinner
import SCLAlertView

class RecuperarSenhaViewController: UIViewController {

    @IBOutlet weak var txtFieldUsername: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    @IBAction func close(_ sender: CustomButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recuperarSenha(_ sender: UIButton) {
        
        SwiftSpinner.show("Enviando...", animated: true)
        
        MobiliteeProvider.api.request(.recoveryPassword(username: self.txtFieldUsername.text!)) { (result) in
            
            SwiftSpinner.hide()
            
            switch (result){
                
            case let .success (response):
                
                do{
                    
                    print(try response.mapJSON())
                    
                }catch{}
            
            case let .failure (error):
                
                print(error.localizedDescription)
                
                
                
            }
        }
        
        
        self.dismiss(animated: true)
    }
    
}
