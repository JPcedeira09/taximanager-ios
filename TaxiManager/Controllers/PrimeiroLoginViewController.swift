//
//  PrimeiroLoginViewController.swift
//  TaxiManager
//
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import TextFieldEffects
import SCLAlertView
import SwiftSpinner
import FirebaseAnalytics

class PrimeiroLoginViewController: UIViewController {
    
    @IBOutlet weak var txtFieldUsuario: HoshiTextField!
    @IBOutlet weak var txtFieldSenha: HoshiTextField!
    @IBOutlet weak var txtFieldConfirmarSenha: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func enviar(_ sender: UIButton) {
        
        if(txtFieldSenha.text!.characters.count  < 5 ||
            txtFieldConfirmarSenha.text!.characters.count < 5
            ){
            
            SCLAlertView().showInfo("Ops!", subTitle: "A senha deve conter 5 dígitos ao menos.")
            
            print("Preencha todos os campos")
        }else if( txtFieldSenha.text != txtFieldConfirmarSenha.text){
            
            SCLAlertView().showInfo("Ops!", subTitle: "A senha digitada deve ser igual nos dois campos.")
            
        }else{
            
            SwiftSpinner.show("Atualizando senha...")
            MobiliteeProvider.api.request(.patchUser(userId: MBUser.currentUser!.id, newPassword: txtFieldSenha.text!), completion: { (result) in
                
                SwiftSpinner.hide()
                
                switch result{
                    
                case let .success(response):
                    
                    do{
                        if let dictionary = try response.mapJSON() as? [String : Any]{
                            
                            print(dictionary)
                            if let _ = dictionary["records"]{
                                SCLAlertView().showSuccess("Tudo pronto!", subTitle: "Agora é só acessar usando sua nova senha.")
                                Analytics.logEvent("firstAccessFormFinishSuccess", parameters: ["user_ID" : MBUser.currentUser!.id])
                            
                                self.dismiss(animated: true)
                            }
                        }
                    }catch{
                        SCLAlertView().showSuccess("Ops!", subTitle: "Erro ao alterar a senha.")
                        self.dismiss(animated: true)
                    }
                    
                case let .failure(error):
                    SCLAlertView().showSuccess("Ops!", subTitle: "Erro ao alterar a senha.")
                    Analytics.logEvent("AccessFormFinishFail", parameters: ["localizedDescription" : error.localizedDescription,"errorDescription" : error.errorDescription!,"Errorresponse" : error.response!])
                    self.dismiss(animated: true)
                }
                
            })
        }
        
    }
}
