//
//  ViewController.swift
//  MobiliteeJPContato
//
//  Created by Joao Paulo on 06/12/17.
//  Copyright © 2017 Joao Paulo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftSpinner
import SCLAlertView
import FirebaseRemoteConfig

class MBContactViewcontroller: UIViewController , CLLocationManagerDelegate {
    
    @IBOutlet weak var textViewInfo: UITextView!
    @IBOutlet weak var textFieldMsg: UITextView!
    //@IBOutlet weak var labelMotivo: UILabel!
    @IBOutlet weak var txtFieldSubject: UITextField!
    @IBOutlet weak var btnEnviarMsg: UIButton!
    var locationManager = CLLocationManager()
    
    //Properties to send location of the feedback.
    var latitude: Double?
    var longitude: Double?
    var remoteConfig: RemoteConfig!
    
    //Properties RemoteConfig.
    var alertSuccessSendFeedbackTitle:String = ""
    var alertSuccessSendFeedbackDescription:String = ""
    var alertFailSendFeedbackTitle:String = ""
    var alertFailSendFeedbackDescription:String = ""
    
    var TitleAlertNoSubjectFeedback:String = ""
    var DescriptionAlertNoSubjectFeedback:String = ""
    var TitleAlertNoMSGFeedback:String = ""
    var DescriptionalertNoMSGFeedback:String = ""
    
    
    func updateViewWithValues(){
        //Remote config Values.
        let titleFeedbackSendAlert = RemoteConfig.remoteConfig().configValue(forKey: "alertSuccessSendFeedbackTitle").stringValue ?? ""
        alertSuccessSendFeedbackTitle = titleFeedbackSendAlert
        print("iNFO title of success menssage send remote config:\(alertSuccessSendFeedbackTitle )")
        
        let DescriptionFeedbackSendAlert = RemoteConfig.remoteConfig().configValue(forKey: "alertSuccessSendFeedbackDescription").stringValue ?? ""
        alertSuccessSendFeedbackDescription = DescriptionFeedbackSendAlert
        print("iNFO description of success menssage send remote config:\(alertSuccessSendFeedbackDescription )")
        
        let titleFeedbackNOSendAlert = RemoteConfig.remoteConfig().configValue(forKey: "alertFailSendFeedbackTitle").stringValue ?? ""
        alertFailSendFeedbackTitle = titleFeedbackNOSendAlert
        print("iNFO title of fail menssage send remote config:\(alertFailSendFeedbackTitle )")
        
        let DescriptionFeedbackNOSendAlert = RemoteConfig.remoteConfig().configValue(forKey: "alertFailSendFeedbackDescription").stringValue ?? ""
        alertFailSendFeedbackDescription = DescriptionFeedbackNOSendAlert
        print("iNFO description of fail menssage send remote config:\(alertFailSendFeedbackDescription )")
        
        //---------
        let alertNoSubjectFeedbackTitle = RemoteConfig.remoteConfig().configValue(forKey: "alertNoSubjectFeedbackTitle").stringValue ?? ""
        TitleAlertNoSubjectFeedback = alertNoSubjectFeedbackTitle
        print("iNFO title of success menssage send remote config:\(TitleAlertNoSubjectFeedback )")
        
        let alertNoSubjectFeedbackDescription = RemoteConfig.remoteConfig().configValue(forKey: "alertNoSubjectFeedbackDescription").stringValue ?? ""
        DescriptionAlertNoSubjectFeedback = alertNoSubjectFeedbackDescription
        print("iNFO description of success menssage send remote config:\(DescriptionAlertNoSubjectFeedback )")
        
        let alertNoMSGFeedbackTitle = RemoteConfig.remoteConfig().configValue(forKey: "alertNoMSGFeedbackTitle").stringValue ?? ""
        TitleAlertNoMSGFeedback = alertNoMSGFeedbackTitle
        print("iNFO title of fail menssage send remote config:\(TitleAlertNoMSGFeedback )")
        
        let alertNoMSGFeedbackDescription = RemoteConfig.remoteConfig().configValue(forKey: "alertNoMSGFeedbackDescription").stringValue ?? ""
        DescriptionalertNoMSGFeedback = alertNoMSGFeedbackDescription
        print("iNFO description of fail menssage send remote config:\(DescriptionalertNoMSGFeedback )")
    }
    
    func fetchRemoteConfig(){
        
        // FIXE: Remove this before we go into productions!
        let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
        var expirationDuration = 2400
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) in
            guard error == nil else {
                print("INFO: Error fetching values- \(error?.localizedDescription ?? "erro!")")
                return
            }
            print("INFO: Firebase Remote Config its ok Tela ")
            RemoteConfig.remoteConfig().activateFetched()
            self.updateViewWithValues()
        }
    }
    
    func setupRemoteConfigDefaults(){
        let defaultsValuesComoUsar = [
            //Remote Config Alerts Mensagens sobre o envio.
            "alertSuccessSendFeedbackTitle":"Enviada!" as NSObject,
            "alertSuccessSendFeedbackDescription":"Mensagem envidada com sucesso!" as NSObject,
            "alertFailSendFeedbackDescription":"Falha no envio da mensagem!" as NSObject,
            "alertFailSendFeedbackTitle":"Falha!" as NSObject,
            
            //Remote Config Alerts preenchimentos.
            "alertNoSubjectFeedbackTitle":"Atenção" as NSObject,
            "alertNoSubjectFeedbackDescription":"Diga-nos o motivo do contato" as NSObject,
            "alertNoMSGFeedbackTitle":"Atenção" as NSObject,
            "alertNoMSGFeedbackDescription":"Diga-nos o que achou" as NSObject
        ]
        RemoteConfig.remoteConfig().setDefaults(defaultsValuesComoUsar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remote Config.
        remoteConfig = RemoteConfig.remoteConfig()
        
        setupRemoteConfigDefaults()
        fetchRemoteConfig()
        
        self.textFieldMsg.delegate = self
        self.txtFieldSubject.delegate = self
        txtFieldSubject.placeholder = "Qual o assunto?"
        let location = self.locationManager.location!
        
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        
        //    self.labelMotivo.text = ""
        self.textViewInfo.isEditable = false
        self.textViewInfo.layer.cornerRadius = 3
        self.textFieldMsg.isEditable = true
        self.textFieldMsg.layer.borderWidth = 2
        self.textFieldMsg.layer.borderColor = UIColor.gray.cgColor
        self.textFieldMsg.layer.cornerRadius = 3
        self.btnEnviarMsg.layer.cornerRadius = 3
        
        self.txtFieldSubject.text = ""
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TODO txt field, longitude e latitude.
    @IBAction func enviarMensagem(_ sender: UIButton) {
        SwiftSpinner.show("Enviando mensagem...")
        print("----------------")
        print(self.txtFieldSubject.text!)
        print(self.textFieldMsg.text!)
        print("----------------")
        
        if(txtFieldSubject.text!.characters.count < 1){
            if(self.TitleAlertNoSubjectFeedback != "" && self.DescriptionAlertNoSubjectFeedback != ""){
                SCLAlertView().showError(self.TitleAlertNoSubjectFeedback, subTitle: self.DescriptionAlertNoSubjectFeedback)
            }else{
                SCLAlertView().showError("", subTitle: "")
            }
            SwiftSpinner.hide()
        }else if (textFieldMsg.text!.characters.count < 1 || textFieldMsg.text! == "Digite aqui sua mensagem."){
            if(self.TitleAlertNoMSGFeedback != "" && self.DescriptionalertNoMSGFeedback != ""){
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("Fechar", action: {self.dismiss(animated: true)})
                alertView.showError(self.TitleAlertNoMSGFeedback, subTitle: self.DescriptionalertNoMSGFeedback)
                
            }else{
                
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("Fechar", action: {self.dismiss(animated: true)})
                alertView.showError("Atenção!", subTitle: "Digite a mensagem que deseja nos passar")
            }
            
            SwiftSpinner.hide()
        }else{
            var feedback = MBFeedback(userId: (MBUser.currentUser?.id)!, subject: txtFieldSubject.text!, message: textFieldMsg.text!
                , platform: "IOS", platformVersion: (Bundle.main.releaseVersionNumber)!, appVersion: Bundle.main.releaseVersionNumberPretty, latitude: latitude!, longitude: longitude!)
            print(feedback.toDict(feedback))
            self.sendFeedBack(feedback: feedback)
        }
    }
    
    /*
     func alertMotivo() {
     let alertController = UIAlertController(title: "Motivo do Contato", message: "Escolha o motivo do seu contato.", preferredStyle: .alert)
     
     let elogio = UIAlertAction(title: "Elogio", style: .default) { UIAlertAction in
     self.labelMotivo.text = "Elogio"
     }
     let sugestao = UIAlertAction(title: "Sugestão", style: .default) { UIAlertAction in
     self.labelMotivo.text = "Sugestão"
     }
     let reclamacao = UIAlertAction(title: "Reclamaçãoo", style: .default) { UIAlertAction in
     self.labelMotivo.text = "Reclamaçãoo"
     }
     let informacao = UIAlertAction(title: "Infromação", style: .default) { UIAlertAction in
     self.labelMotivo.text = "Infromação"
     }
     alertController.addAction(elogio)
     alertController.addAction(sugestao)
     alertController.addAction(reclamacao)
     alertController.addAction(informacao)
     
     self.present(alertController, animated: true, completion: nil)
     }*/
    
    func sendFeedBack( feedback: MBFeedback)-> String{
        let parametros : [String: Any]  =  feedback.toDict(feedback) as [String:Any]
        let postURL = URL(string:  "https://api.taximanager.com.br/v1/taximanager/feedback")
        
        let header = ["Content-Type" : "application/json",
                      "Authorization" : MBUser.currentUser?.token ?? ""]
        
        Alamofire.request(postURL!, method: .post, parameters:parametros , encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON {  response in
            
            SwiftSpinner.hide()
            
            switch response.result {
            case .success(let data):
                print(data)
                
                let feedbackTitle = self.alertSuccessSendFeedbackTitle != "" ? self.alertSuccessSendFeedbackTitle : "Enviada!"
                let feedbackDescription = self.alertSuccessSendFeedbackDescription != "" ? self.alertSuccessSendFeedbackDescription : "A mensagem foi enviada com sucesso!"
                
                let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("Fechar", action: {self.dismiss(animated: true)})
                alertView.showSuccess(feedbackTitle, subTitle: feedbackDescription)
                
                //                alertView.addButton("Second Button") {
                //                    print("Second button tapped")
                //                }
                //                alertView.setDismissBlock {
                //                    self.dismiss(animated: true)
                //                }
                
            case .failure(let error):
                print(error.localizedDescription)
                print("iNFO: error in localizedDescription getBookmarks")
                
                if(self.alertFailSendFeedbackTitle == "" || self.alertFailSendFeedbackDescription == ""){
                    
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("Fechar", action: {self.dismiss(animated: true)})
                    alertView.showError("Falha ao adicionar favorito", subTitle: "Tente mais tarde.")
                    
                }else{
                    
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("Fechar", action: {self.dismiss(animated: true)})
                    alertView.showError(self.alertFailSendFeedbackTitle, subTitle: self.alertFailSendFeedbackDescription)
                }
            }
        }
        return feedback.message
    }
}

extension MBContactViewcontroller : UITextFieldDelegate, UITextViewDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFieldSubject.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
            return true
        }
        textFieldMsg.resignFirstResponder()
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textFieldMsg.text = ""
        textFieldMsg.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textFieldMsg.text.isEmpty {
            textFieldMsg.text = "Digite aqui sua mensagem."
            textFieldMsg.textColor = UIColor.lightGray
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
}
extension UIViewController {
    
    func alertComum(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let setTipoMSG = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
        }
        alertController.addAction(setTipoMSG)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

