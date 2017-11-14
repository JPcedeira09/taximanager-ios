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
        
        self.checarPrecos()
        
    
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
//        do{
//
//
//            let body = try JSONSerialization.data(withJSONObject: parametros)
//
//            print("XXXXXXXXXXXXXXXXXXX")
//            print(parametros)
//            print("XXXXXXXXXXXXXXXXXXX")
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue(autorizationKey, forHTTPHeaderField: "Authorization")
//            request.httpBody = body
//            let session = URLSession.shared
//            let task = session.dataTask(with: request){
//                (data, response, error) in
//
//                SwiftSpinner.hide()
//                if(error == nil){
//
//                    print(response)
//
//                    do{
//                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
//
//                        let origem = jsonData["start"] as! [String : AnyObject]
//                        let destino = jsonData["end"] as! [String : AnyObject]
//
//                        guard let endOrigem = origem["address"] as! String? else {
//                            print("falhou end origem")
//                            return
//                        }
//
//                        guard let endDestino = destino["address"] as! String? else {
//                            print("falhou end destino")
//                            return
//                        }
//
//                        guard let records = jsonData["records"] as? [[String : AnyObject]] else {
//
//                            let alerta = SCLAlertView()
//                            alerta.showInfo("Ops!", subTitle: "Não conseguimos encontrar motoristas para estes endereços.")
//                            return
//                        }
//
//                        var arrayCorridas : [Corrida] = []
//
//                        for record in records{
//
//                            var novaCorrida = Corrida()
//
//                            if let alertMessage = record["alert_message"] as? String{
//                                novaCorrida.alertMessage = alertMessage
//                            }
//
//                            if let id = record["id"] as? Int {
//                                novaCorrida.id = id
//                            }
//                            if let name = record["name"] as? String{
//
//                                novaCorrida.name = name
//                            }
//
//                            if let modality = record["modality"] as? [String : AnyObject]{
//
//                                if let name = modality["name"] as? String{
//
//                                    novaCorrida.modalityName = name
//                                }
//                            }
//
//                            if let price = record["price"] as? String {
//
//                                novaCorrida.price = price
//                            }
//
//                            if let waitingTime = record["waiting_time"] as? Int{
//
//                                novaCorrida.waitingTime = waitingTime
//                            }
//
//                            if let urlDeepLinkString = record["url"] as? String{
//
//                                novaCorrida.urlDeeplink = URL(string: urlDeepLinkString)
//                            }
//
//                            if let urlLogoString = record["url_logo"] as? String{
//
//                                novaCorrida.urlLogo = URL(string: urlLogoString)
//                            }
//
//                            if let urlLojaString = record["url_loja_ios"] as? String{
//
//                                novaCorrida.urlLoja = URL(string: urlLojaString)
//                            }
//
//                            if let urlWebString = record["url_web"] as? String{
//
//                                novaCorrida.urlWeb = URL(string: urlWebString)
//                            }
//
//
//                            arrayCorridas.append(novaCorrida)
//
//                            let resumo = ResumoBusca(enderecoOrigem: endOrigem, enderecoDestino: endDestino, duracaoCorrida: duracao, distanciaCorrida: distancia, arrayCorridas: arrayCorridas)
//
//                            self.resumoBusca = resumo
//                            print("========== RESUMO =========")
//                            print(resumo)
//                            DispatchQueue.main.sync {
//                                self.performSegue(withIdentifier: "segueTelaBusca", sender: nil)
//                            }
//
//                        }
//
//
//
//
//                    }catch{
//
//                        //                        let alerta = SCLAlertView()
//                        //                        alerta.showInfo("Não enco", subTitle: <#T##String#>)
//                        print("NAO DEU CERTO PEGAR O NEGOCIO")
//                    }
//
//                }
//            }
//
//            task.resume()
//
//
//        }catch{}
//
        
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
