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

                        let mbUser = MBUser(from: dictionary)

                        print(mbUser)
                        let userEncoded = try JSONEncoder().encode(mbUser)

                        MBUser.update()

                        let defaults = UserDefaults.standard
                        defaults.set(userEncoded, forKey: "user")
                        defaults.synchronize()


                        if (MBUser.currentUser?.firstAccessAt == nil){
                            
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let alert = SCLAlertView(appearance: appearance)
                            alert.addButton("Ok", action: {
                                self.performSegue(withIdentifier: "tmPrimeiroAcesso", sender: nil)
                            })
                            alert.showSuccess("Seja bem vindo!", subTitle: "Troque sua senha agora. A nova senha deve conter no mínimo 5 dígitos.")
                            
                        
                           
                        }else{

                            self.performSegue(withIdentifier: "tmTelaPrincipal", sender: nil)
                        }

                    }catch{

                        print("Nao conseguiu pegar dicionario")
                    }
                }else{
                    
                    let alert = SCLAlertView()
                    alert.showError("Erro", subTitle: "Usuário ou senha inválidos.")
                    
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
