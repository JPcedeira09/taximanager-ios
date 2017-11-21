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

class MBLoginViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    //MARK: - Propriedades
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.textFieldUsername.delegate = self
        self.textFieldPassword.delegate = self
        
    }
    
    
    override var canBecomeFirstResponder: Bool{
        
        return true
    }
    //MARK: - Metodos
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.becomeFirstResponder()
    }
    
    
    func login(username : String, password : String){
        
        SwiftSpinner.show("Efetuando login...")
        
        MobiliteeProvider.api.request(.login(username: username, password: password)) { (result) in
          
            SwiftSpinner.hide()
            switch result{
                
            case let .success(response):
                
                print("Success")
                
                print(String(data: response.data, encoding: .utf8))
                
                if response.statusCode == 200{
                    print("status 200")
                    do{
                        guard let dictionary = try response.mapJSON() as? [String : Any] else {
                            return
                        }
                        
                        let mbUser = MBUser(from: dictionary)
                        
                        print(mbUser)
                        let userEncoded = try JSONEncoder().encode(mbUser)
                        
                        MBUser.update()
                        
                        UserDefaults.standard.set(userEncoded, forKey: "user")
                        
                        let defaults = UserDefaults.standard
                        defaults.set(mbUser.id, forKey: "idUsuario")
                        defaults.set(mbUser.companyId, forKey: "idEmpresa")
                        defaults.set(mbUser.firstName, forKey: "nomeUsuario")
                        defaults.set(mbUser.lastName, forKey: "sobrenomeUsuario")
                        defaults.set(mbUser.employeeId, forKey: "employeeId")
                        defaults.set(mbUser.token, forKey: "token")
                        
                        defaults.synchronize()
                        
                        self.performSegue(withIdentifier: "tmTelaPrincipal", sender: nil)

                        
                    }catch{
                        
                        print("Nao conseguiu pegar dicionario")
                    }
                }
            case let .failure(error):
                
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
    
    func checarPrecos(){
        
        //passar user_id e company_id
        
        let idUsuario = 139
        let idEmpresa = 3
        
        let device = [
            "id":"",
            "operation_system":"macintel",
            "operation_system_version":"0",
            "device":"",
            "type_connection":"",
            "version_app":"v1.3.0"
        ]
        
        let start = [
            "lat": -15.762023,
            "lng": -47.891636,
            "address":"Rua Augusta - Consolação, São Paulo - SP, Brasil",
            "district":"Consolação",
            "city":"São Paulo",
            "state":"SP",
            "zipcode":""
        ] as [String : Any]
        let end = [
            "lat": -15.834928,
            "lng": -47.912829,
            "address":"Rua Pamplona - Jardim Paulista, São Paulo - SP, Brasil",
            "district":"",
            "city":"São Paulo",
            "state":"SP",
            "zipcode":""
        ] as [String : Any]
        let distance = 3200
        let duration = 11
//        "user_id" : 139,
//        "company_id" : 3
        

        let parametros = ["device" : device, "start" : start, "end" : end, "distance" : distance , "duration" : duration, "company_id" : idEmpresa, "user_id" : idUsuario] as [String : Any]
        
        let data = try? JSONSerialization.data(withJSONObject: parametros, options: .prettyPrinted)
        
        print(String(data: data!, encoding: .utf8))
        
        let url = URL(string: "http://estimate.taximanager.com.br/v1/estimates")!
        let autorizationKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNTAwMzM4MjU0fQ.B2Nch63Zu0IzJDepVTDXqq8ydbIVDiUmU6vV_7eQocw"
        
        
        let headers = ["Content-Type" : "application/json",
                       "Authorization" : autorizationKey]
        
        
        Alamofire.request(url, method: .post, parameters: parametros, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
        }
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
