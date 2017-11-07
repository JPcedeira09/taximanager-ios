//
//  TMLoginViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 19/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
import GooglePlaces
import SwiftSpinner


class TMLoginViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var textFieldUsuario: UITextField!
    
    @IBOutlet weak var textFieldSenha: UITextField!
    //MARK: - Propriedades
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        

        self.textFieldUsuario.delegate = self
        self.textFieldSenha.delegate = self
        
    
    }
    
    
    override var canBecomeFirstResponder: Bool{
        
        return true
    }
    //MARK: - Metodos
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.becomeFirstResponder()
    }
    
    
    func efetuarLogin(usuario : String, senha : String){
        
        SwiftSpinner.show("Efetuando login...")
        
        let tokenString = usuario + ":" + senha
        let base64Token = tokenString.toBase64()
        var headers = HTTPHeaders()
        headers["Authorization"] = "Basic :" + base64Token
        
        Alamofire.request("https://api.taximanager.com.br/v1/taximanager/users/login", method: .get, headers: headers).responseJSON { (response) in
            
            if(response.error == nil){
                SwiftSpinner.hide()
                if let json = response.result.value as? [String : AnyObject]{
                    
                    print(json)
                    let errorCode = json["errorCode"] as? Int
                    
                    if let _ = errorCode{
                        let aparencia = SCLAlertView.SCLAppearance(
                            kTitleFont: UIFont(name: "Poppins-SemiBold", size: 20)!,
                            kTextFont: UIFont(name: "Poppins", size: 16)!,
                            kButtonFont: UIFont(name: "Poppins", size: 16)!
                        )
                        let alerta = SCLAlertView(appearance: aparencia)
                        alerta.showError("Usuario ou senha inválida", subTitle: "Tente novamente")
                        
                        
                        
                    }else{
                        
                        if let records = json["records"] as? [[String : AnyObject]]{
                            
                            let usuario = records[0]
                            let idUsuario = usuario["id"] as? Int
                            let nomeUsuario = usuario["firstName"] as! String
                            let sobrenomeUsuario = usuario["lastName"] as! String
                            let employeeId = usuario["employeeId"] as! Int
                            let empresa = usuario["companyEmployee"] as! [String : AnyObject]
                            let idEmpresa = empresa["companyId"] as! Int
                            let token = usuario["token"] as! String

                            
                            let defaults = UserDefaults.standard
                            defaults.set(idUsuario, forKey: "idUsuario")
                            defaults.set(idEmpresa, forKey: "idEmpresa")
                            defaults.set(nomeUsuario, forKey: "nomeUsuario")
                            defaults.set(sobrenomeUsuario, forKey: "sobrenomeUsuario")
                            defaults.set(employeeId, forKey: "employeeId")
                            defaults.set(token, forKey: "token")
                            
                            defaults.synchronize()
                            
                            self.performSegue(withIdentifier: "tmTelaPrincipal", sender: nil)
                            
                            
                            
                        }
                    }
                }
                
                
            }
        }
        
    }
    
    func verificaConteudosTextField() -> Bool{
        
        self.view.becomeFirstResponder()
        
        if(self.textFieldUsuario.text != "" && self.textFieldSenha.text != ""){
            
            return true
        }
        
        return false
        
    }
    
    
    //MARK: - IBActions
    
    @IBAction func logar(_ sender: UIButton) {
        
        if(verificaConteudosTextField()){
            
            self.efetuarLogin(usuario: self.textFieldUsuario.text!, senha: self.textFieldSenha.text!)
        }
    }
}


extension TMLoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == self.textFieldSenha && self.verificaConteudosTextField()){
            
            self.efetuarLogin(usuario: self.textFieldUsuario.text!, senha: self.textFieldSenha.text!)
            
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}
