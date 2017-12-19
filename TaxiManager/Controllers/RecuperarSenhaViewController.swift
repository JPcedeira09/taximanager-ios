//
//  RecuperarSenhaViewController.swift
//  TaxiManager
//
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import TextFieldEffects
import SwiftSpinner
import SCLAlertView
import FirebaseAnalytics

class RecuperarSenhaViewController: UIViewController {
    
    @IBOutlet weak var txtFieldUsername: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("forgotPasswordStart", parameters: ["iNFO":"Tentou redefinir senha" ])
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
                    SCLAlertView().showError("Sucesso", subTitle: "Envio de redefinição completo")
                    Analytics.logEvent("forgotPasswordFinishedSuccess", parameters: ["User_digitado": self.txtFieldUsername.text!,"success": "\(try response.mapJSON())" ])
                }catch{
                    SCLAlertView().showError("Falha", subTitle: "Envio de redefinição falhou ao ler o JSON")
                    Analytics.logEvent("forgotPasswordFinishedSuccessButFailSerialization", parameters: ["User_digitado": self.txtFieldUsername.text!,"Fail": "\(error.localizedDescription)" ])
                }
            case let .failure (error):
                SCLAlertView().showError("Falha", subTitle: "Envio de redefinição falhou")
                print(error.localizedDescription)
                Analytics.logEvent("forgotPasswordFinishedFail", parameters: ["User_digitado": self.txtFieldUsername.text!,"Fail": "\(error.localizedDescription)" ])
            }
        }
        self.dismiss(animated: true)
    }
    
}
