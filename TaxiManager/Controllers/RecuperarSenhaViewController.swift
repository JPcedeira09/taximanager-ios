//
//  RecuperarSenhaViewController.swift
//  TaxiManager
//
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import TextFieldEffects
import SwiftSpinner
import SCLAlertView
import FirebaseAnalytics
import Alamofire

class RecuperarSenhaViewController: UIViewController {
    
    @IBOutlet weak var txtFieldUsername: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.logEvent("forgotPasswordStart", parameters: ["iNFO":"Tentou redefinir senha" ])
    }
    
    @IBAction func close(_ sender: CustomButton) {
        self.dismiss(animated: true, completion: nil)
            }
    
    @IBAction func recuperarSenha(_ sender: UIButton) {
        
        SwiftSpinner.show("Enviando...", animated: true)
        
        MobiliteeProvider.api.request(.recoveryPassword(username: self.txtFieldUsername.text!)) { (result) in
            
            SwiftSpinner.hide()
            switch (result){
            case let .success (response):
                do{
                    SCLAlertView().showSuccess("Sucesso", subTitle: "Envio de redefinição completo")
                    Analytics.logEvent("forgotPasswordFinishedSuccess", parameters: ["User_digitado": self.txtFieldUsername.text!,"success": "\(try response.mapJSON())" ])
                    print(try response.mapJSON())
                }catch{
                    //SCLAlertView().showError("Falha", subTitle: "Envio de redefinição falhou ao ler o JSON")
                    Analytics.logEvent("forgotPasswordFinishedSuccessButFailSerialization", parameters: ["User_digitado": self.txtFieldUsername.text!,"Fail": "\(error.localizedDescription)" ])
                }
            case let .failure (error):
                SCLAlertView().showError("Falha", subTitle: "Envio de redefinição falhou")
                print(error.localizedDescription)
                Analytics.logEvent("forgotPasswordFinishedFail", parameters: ["User_digitado": self.txtFieldUsername.text!,"Fail": "\(error.localizedDescription)" ])
            }
        }
        self.dismiss(animated: true)
    }
    
    
    func redefinirSenha(){
        let url = URL(string: "http://api.taximanager.com.br/v1/taximanager/employees/bookmarks")
        Alamofire.request(
            url!,
            method: .get)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success(let data):
                    guard let json = data as? [String : NSObject] else {
                        return
                    }
                    var mbBookmarks  : [MBBookmark] = []
                    let records = json["records"] as! NSArray
                    for item in records {
                        let bookmark = MBBookmark(serializable: item as! [String : Any])
                        //  print("iNFO BOOKMARK \n :\(bookmark)")
                        mbBookmarks.append(bookmark)
                    }
                    MBUser.currentUser?.bookmarks = mbBookmarks
                case .failure(let error):
                    print(error.localizedDescription)
                    print("iNFO: error in localizedDescription getBookmarks")
                }
        }
    }
}
