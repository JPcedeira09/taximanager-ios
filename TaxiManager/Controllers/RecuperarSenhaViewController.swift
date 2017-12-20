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
import Alamofire

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
        redefinirSenha(username : self.txtFieldUsername.text!)
        SwiftSpinner.hide()
        
        self.dismiss(animated: true)
    }
    
    func redefinirSenha(username : String){
        let url = URL(string: "https://api.taximanager.com.br/v1/taximanager/users/password/recovery")
        let parameters = ["username" : username]
        let header = ["Content-Type" : "application/json"]
        let request = Alamofire.request(
            url!,
            method: .get, parameters : parameters, headers : header)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let data):
                    guard let json = data as? [String : NSObject] else {return}
                    let user = MBUser(from: json)
                    print(user)
                    if(user.username != "" ){
                        SCLAlertView().showSuccess("Sucesso", subTitle: "Envio de redefinição completo")
                    }else{
                        SCLAlertView().showError("Falha", subTitle: "Usuario Inexistente, digite novamente")
                    }
                case .failure(let error):
                    SCLAlertView().showError("Falha", subTitle: "Envio de redefinição falhou")
                    print(error.localizedDescription)
                    Analytics.logEvent("forgotPasswordFinishedFail", parameters: ["User_digitado": self.txtFieldUsername.text!,"Fail": "\(error.localizedDescription)" ])
                }
        }
        print(request)
    }
}

/*
 func redefinirSenhaMOYA (username : String){
 MobiliteeProvider.api.request(.recoveryPassword(username: username)) { (result) in
 
 switch (result){
 case let .success (response):
 do{
 SCLAlertView().showSuccess("Sucesso", subTitle: "Envio de redefinição completo")
 Analytics.logEvent("forgotPasswordFinishedSuccess", parameters: ["User_digitado": self.txtFieldUsername.text!,"success": "\(try response.mapJSON())" ])
 print(try response.mapJSON())
 }catch{
 //SCLAlertView().showError("Falha", subTitle: "Envio de redefinição falhou ao ler o JSON")
 Analytics.logEvent("forgotPasswordFinishedSuccessButFailSerialization", parameters: ["User_digitado": self.txtFieldUsername.text!,"Fail": "\(error.localizedDescription)" ])
 }
 case let .failure (error):
 SCLAlertView().showError("Falha", subTitle: "Envio de redefinição falhou")
 print(error.localizedDescription)
 Analytics.logEvent("forgotPasswordFinishedFail", parameters: ["User_digitado": self.txtFieldUsername.text!,"Fail": "\(error.localizedDescription)" ])
 }
 }
 }
 */
