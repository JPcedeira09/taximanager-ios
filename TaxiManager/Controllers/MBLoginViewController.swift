//
//  TMLoginViewController.swift
//  TaxiManager
//
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
import GooglePlaces
import SwiftSpinner
import FirebaseAnalytics

class MBLoginViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var btnEnviar: CustomButton!
    //MARK: - Propriedades
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldUsername.delegate = self
        self.textFieldPassword.delegate = self
        btnEnviar.layer.cornerRadius = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.textFieldPassword.text = ""
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //MARK: - Metodos
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    func login(username : String, password : String){
        
        self.becomeFirstResponder()
        SwiftSpinner.show("Efetuando login...")
        
        MobiliteeProvider.api.request(.login(username: username, password: password)) { (result) in
            
            SwiftSpinner.hide()
            switch result{
                
            case let .success(response):
                
                if response.statusCode == 200{
                    print("status 200")
                    
                    do{
                        guard let dictionary = try response.mapJSON() as? [String : Any] else {
                            return
                        }
                        print("INFO DICT LOGIN:---------------------")
                        print(dictionary)
                        print("INFO DICT LOGIN:---------------------")
                        let mbUser = MBUser(from: dictionary)
                        
                        print("O ID do user é :\(mbUser.id)")
                        print("O ID do employee é :\(mbUser.employeeId)")
                        
                        let userEncoded = try JSONEncoder().encode(mbUser)
                        
                        MBUser.update()
                        
                        let defaults = UserDefaults.standard
                        defaults.set(userEncoded, forKey: "user")
                        defaults.synchronize()
                        
                        //  INFO: inactive status.
                        if(mbUser.statusID == 2){
                            
                            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                            let alertInativo = SCLAlertView(appearance: appearance)
                            alertInativo.addButton("Fechar", action: {self.dismiss(animated: true)})
                            alertInativo.showError("Falha", subTitle: "Envio de redefinição falhou")
                            alertInativo.showNotice("Ops...", subTitle: "Ops, seu usuário não está ativo. Por favor, entre em contato com a área de transporte da sua empresa.")
                            //  INFO: fired status.
                            
                        }else if (mbUser.statusID == 3){
                            
                            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                            let alertDemitido = SCLAlertView(appearance: appearance)
                            alertDemitido.addButton("Fechar", action: {self.dismiss(animated: true)})
                            alertDemitido.showError("Falha", subTitle: "Envio de redefinição falhou")
                            alertDemitido.showNotice("Ops...", subTitle: "Ops, seu usuario não está abilitado, entre em contato com a área de transporte da sua empresa.")
                            // INFO: first access, enable status.
                            
                        }else if (MBUser.currentUser?.firstAccessAt == nil && mbUser.statusID == 1){
                            
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let alert = SCLAlertView(appearance: appearance)
                            alert.addButton("Fechar", action: {
                                self.performSegue(withIdentifier: "tmPrimeiroAcesso", sender: nil)
                                
                                Analytics.logEvent("firstAccessFormFinishSuccess", parameters: ["user" : username])
                            })
                            alert.showSuccess("Seja bem vindo!", subTitle: "Troque sua senha agora. A nova senha deve conter no mínimo 5 dígitos.")
                            
                        }else{
                            self.performSegue(withIdentifier: "tmTelaPrincipal", sender: nil)
                        }
                    }catch{
                        print("Nao conseguiu pegar dicionario")
                    }
                }else{
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("Fechar", action: {self.dismiss(animated: true)})
                    alertView.showError("Falha", subTitle: "Envio de redefinição falhou")
                    alertView.showError("Erro!", subTitle: "Usuário ou senha inválidos.")
                }
            case let .failure(error):
                Analytics.logEvent("AccessFormFinishFail", parameters: ["localizedDescription" : error.localizedDescription,"errorDescription" : error.errorDescription!,"Errorresponse" : error.response!])
                print(error.localizedDescription)
            }
        }
    }
    
    func verificaConteudosTextField() -> Bool{
        self.view.becomeFirstResponder()
        
        if(self.textFieldUsername.text != "" && self.textFieldPassword.text != ""){
            
            return true
        }
        
        return false
        
    }
    //MARK: - IBActions
    @IBAction func logar(_ sender: UIButton) {
        
        if(verificaConteudosTextField()){
            
            self.login(username: self.textFieldUsername.text!, password: self.textFieldPassword.text!)
        }
    }
}

extension MBLoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == self.textFieldPassword && self.verificaConteudosTextField()){
            
            self.login(username: self.textFieldUsername.text!, password: self.textFieldPassword.text!)
            
        }
        
        return true
    }
    
}
