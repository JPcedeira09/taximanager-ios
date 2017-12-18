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

class MBContactViewcontroller: UIViewController {
    
    @IBOutlet weak var textViewInfo: UITextView!
    @IBOutlet weak var textFieldMsg: UITextView!
    //@IBOutlet weak var labelMotivo: UILabel!
    @IBOutlet weak var txtFieldSubject: UITextField!
    @IBOutlet weak var btnEnviarMsg: UIButton!
    var locationManager = CLLocationManager()
    
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        // labelMotivo.text = ""
    }
    
    //TODO txt field, longitude e latitude.
    
    @IBAction func enviarMensagem(_ sender: UIButton) {
        self.becomeFirstResponder()
        var feedback = Feedback(userId: (MBUser.currentUser?.id)!, subject: txtFieldSubject.text!, message: textFieldMsg.text!
            , platform: "IOS", platformVersion: (Bundle.main.releaseVersionNumber)!, appVersion: Bundle.main.releaseVersionNumberPretty, latitude: latitude!, longitude: longitude!)
        
        print(feedback.toDict(feedback))
        
        var mensagem = self.sendFeedBack(feedback: feedback)
        self.becomeFirstResponder()
        print("A mensagem enviada foi '\(mensagem)'")
        self.dismiss(animated: true, completion: nil)
        
        /*  if (self.labelMotivo.text == ""){
         alertComum(message: "Escolha o motivo do seu contato", title: "Motivo do Contato")
         } */
        
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
            print(response)
            SwiftSpinner.hide()
        }
        return feedback.message
    }
}
extension MBContactViewcontroller : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textFieldMsg.text = ""
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
        self.textFieldMsg.text = ""
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

