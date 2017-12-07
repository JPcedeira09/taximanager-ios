//
//  ViewController.swift
//  MobiliteeJPContato
//
//  Created by Joao Paulo on 06/12/17.
//  Copyright © 2017 Joao Paulo. All rights reserved.
//

import UIKit
import Alamofire

class MBContactViewcontroller: UIViewController {
    
    @IBOutlet weak var textViewInfo: UITextView!
    @IBOutlet weak var textFieldMsg: UITextView!
    @IBOutlet weak var labelMotivo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         {
         "user_id" : 5,
         "company_id": 3,
         "selected" : 2,
         "type_open" : 2
         } */
        let  mbPlayerchosed = MBPlayeyChoose(user_id: 4, company_id: 3, selected: 29, type_open: 3)
        sendUser(mbPlayerchosed)
        
        self.labelMotivo.text = ""
        self.textViewInfo.isEditable = false
        self.textFieldMsg.isEditable = true
       self.textFieldMsg.layer.borderWidth = 1
        self.textFieldMsg.layer.borderColor = UIColor.gray.cgColor
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //MARK: - methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        labelMotivo.text = ""
        
    }
    
    @IBAction func openMotivoContato(_ sender: UIButton) {
        alertMotivo()
    }
    
    @IBAction func enviarMensagem(_ sender: UIButton) {
        if (self.labelMotivo.text == ""){
            alertComum(message: "Escolha o motivo do seu contato", title: "Motivo do Contato")
        }
    }
    

//func send playerInfo
    func sendUser(_ mbInfoPlayer: MBPlayeyChoose){
        let parametros =  mbInfoPlayer.toDict(mbInfoPlayer) as [String:Any]

        let postURL = "https://estimate.taximanager.com.br/v1/estimate/selected"
        // prepare json data
        let json: [String: Any] =  parametros
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: postURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // insert json data to the request
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if (error == nil){
                print("====== 200 =========")
            }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()
}
//        print(mbInfoPlayer)
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = body
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { (data, response,error) in
//            if (error == nil){
//                print("success")
//            }
//        }

    
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

