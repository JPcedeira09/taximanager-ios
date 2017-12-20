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

class MBContactViewcontroller: UIViewController {
    @IBOutlet weak var textViewInfo: UITextView!
    @IBOutlet weak var textFieldMsg: UITextView!
    //@IBOutlet weak var labelMotivo: UILabel!
    @IBOutlet weak var txtFieldSubject: UITextField!
    @IBOutlet weak var btnEnviarMsg: UIButton!
    var locationManager = CLLocationManager()
    
    //Properties to send location of the feedback.
    var latitude: Double?
    var longitude: Double?
    
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
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { (status, error) in
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
        //setupRemoteConfigDefaults()
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
        
    
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TODO txt field, longitude e latitude.
    @IBAction func enviarMensagem(_ sender: UIButton) {
        
        
        if (self.textViewInfo.text! == "" ){
            if(self.TitleAlertNoSubjectFeedback == "" || self.DescriptionAlertNoSubjectFeedback == ""){
                alertComum(message: "Atenção!", title: "Diga-nos o motivo do contato!")
            }else{
                alertComum(message: self.TitleAlertNoSubjectFeedback, title: self.DescriptionAlertNoSubjectFeedback)
            }
        }
        if (self.textFieldMsg.text! == "") {
            if(self.TitleAlertNoMSGFeedback == "" || self.DescriptionalertNoMSGFeedback == ""){
                alertComum(message: "Atenção!", title: "Diga-nos o que achou!")
            }else{
                alertComum(message: self.TitleAlertNoMSGFeedback, title: self.DescriptionalertNoMSGFeedback)
            }
        }else{
            
            self.becomeFirstResponder()
            var feedback = Feedback(userId: (MBUser.currentUser?.id)!, subject: txtFieldSubject.text!, message: textFieldMsg.text!
                , platform: "IOS", platformVersion: (Bundle.main.releaseVersionNumber)!, appVersion: Bundle.main.releaseVersionNumberPretty, latitude: latitude!, longitude: longitude!)
            
            print(feedback.toDict(feedback))
            
            let mensagem = self.sendFeedBack(feedback: feedback)
            self.becomeFirstResponder()
            print("A mensagem enviada foi '\(mensagem)'")
            self.dismiss(animated: true, completion: nil)
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
    
    func sendFeedBack( feedback: Feedback)-> String{
        SwiftSpinner.show("Enviando mensagem...")
        let parametros : [String: Any]  =  feedback.toDict(feedback) as [String:Any]
        let postURL = URL(string:  "http://api.taximanager.com.br/v1/taximanager/feedback")
        
        let header = ["Content-Type" : "application/json",
                      "Authorization" : MBUser.currentUser?.token ?? ""]
        Alamofire.request(postURL!, method: .post, parameters:parametros , encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON {  response in
            
            switch response.result {
            case .success(let data):
                print(response)
                SwiftSpinner.hide()
                
                if(self.alertSuccessSendFeedbackTitle == "" || self.alertSuccessSendFeedbackDescription == ""){
                    SCLAlertView().showSuccess("Mensagem enviada!", subTitle: "Obrigado pelo seu feedback .")
                }else{
                    SCLAlertView().showSuccess(self.alertSuccessSendFeedbackTitle, subTitle: self.alertSuccessSendFeedbackDescription)
                }
                
            case .failure(let error):
                SwiftSpinner.hide()
                print(error.localizedDescription)
                print("iNFO: error in localizedDescription getBookmarks")
                
                if(self.alertFailSendFeedbackTitle == "" || self.alertFailSendFeedbackDescription == ""){
                    SCLAlertView().showError("Falha ao adicionar favorito", subTitle: "Tente mais tarde.")
                }else{
                    SCLAlertView().showError(self.alertFailSendFeedbackTitle, subTitle: self.alertFailSendFeedbackDescription)
                }
            }
        }
        return feedback.message
    }
}

extension MBContactViewcontroller : UITextFieldDelegate, UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            textFieldMsg.text = ""
            textFieldMsg.textColor = UIColor.black
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textFieldMsg.text.isEmpty {
            textFieldMsg.text = "Digite aqui sua mensagem"
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

