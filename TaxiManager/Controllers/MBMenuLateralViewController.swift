 //
 //  TMMenuLateralViewController.swift
 //  TaxiManager
 //
 //  Created by Esdras Martins on 26/10/17.
 //  Copyright © 2017 Taxi Manager. All rights reserved.
 //
 
 import UIKit
 import SCLAlertView
 import MessageUI
 import FirebaseRemoteConfig
 import Firebase
 
 class MBMenuLateralViewController: UIViewController {
    
    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var btnVersion: UIButton!
    
    @IBOutlet weak var comoUsarButton: UIButton!
    @IBOutlet weak var politicasDeUso: UIButton!
    @IBOutlet weak var SairButton: UIButton!
    
    
    var urlTermsOfUse:String = ""
    var urlHowUse:String = ""
    var alertLogoutTitle:String = ""
    var alertLogoutDescription:String = ""
    var remoteConfig: RemoteConfig!
    
    func updateViewWithValues(){
        //Remote Config button terms of use.
        let buttonTerms = RemoteConfig.remoteConfig().configValue(forKey: "button_terms_of_use").stringValue ?? ""
        politicasDeUso.setTitle(buttonTerms, for: .normal)
        print("iNFO button terms of use:\(buttonTerms)")
        
        //Remote config url terms of use
        let urlTerms = RemoteConfig.remoteConfig().configValue(forKey: "url_terms_of_use").stringValue ?? ""
        urlTermsOfUse = urlTerms
        print("iNFO url terms of use remote config:\(urlTermsOfUse)")
        
        //Remote config button how use.
        let buttonHow = RemoteConfig.remoteConfig().configValue(forKey: "button_how_use").stringValue ?? ""
        comoUsarButton.setTitle(buttonHow, for: .normal)
        print("iNFO button how use:\(buttonHow)")
        
        //Remote config url how use.
        let urlUse = RemoteConfig.remoteConfig().configValue(forKey: "urls_how_use").stringValue ?? ""
        urlHowUse = urlUse
        print("iNFO url how use remote config:\(urlHowUse)")
        
        //Remote config logout Alert Title.
        let alertTitleLogout = RemoteConfig.remoteConfig().configValue(forKey: "logout_alert_title").stringValue ?? ""
        alertLogoutTitle = alertTitleLogout
        print("iNFO alert logout title remote config:\(alertLogoutTitle)")
        
        //Remote config url how use.
        let alertDescriptionLogout = RemoteConfig.remoteConfig().configValue(forKey: "logout_alert_description").stringValue ?? ""
        alertLogoutDescription = alertDescriptionLogout
        print("iNFO alert logout description remote config:\(alertLogoutDescription)")
    }
    
    func fetchRemoteConfig(){
        // FIXE: Remove this before we go into productions!
         let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
        
        var expirationDuration = 2400
        if remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) in
            
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
                self.updateViewWithValues()
                print("INFO: Firebase Remote Config its ok")
            } else {
                print("Config not fetched")
                print("iNFO_Error: \(error!.localizedDescription)")
            }
        }
    }
    
    func setupRemoteConfigDefaults(){
        let defaultsValuesComoUsar = [
            "button_terms_of_use":"Termos de Uso" as NSObject,
            "url_terms_of_use":"https://mobilitee.com.br/itau/termos-de-uso/" as NSObject,
            "urls_how_use":"https://mobilitee.com.br/itau/como-usar/" as NSObject,
            "button_how_use":"Como Usar" as NSObject,
            "logout_alert_title":"Sair!" as NSObject,
            "logout_alert_description":"Você deseja sair?" as NSObject,
            ]
        RemoteConfig.remoteConfig().setDefaults(defaultsValuesComoUsar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        remoteConfig = RemoteConfig.remoteConfig()
        setupRemoteConfigDefaults()
        fetchRemoteConfig()
        
        let nome = MBUser.currentUser?.firstName
        let sobrenome = MBUser.currentUser?.lastName
        
        self.labelNome.text = nome! + " " + sobrenome!
        self.btnVersion.setTitle(Bundle.main.releaseVersionNumberPretty, for: .normal)
    }
    
    @IBAction func sair(_ sender: UIButton) {
        
        let alert = SCLAlertView()
        
        if(self.alertLogoutTitle == "" || self.alertLogoutDescription == ""){
            alert.addButton("Sair", action: {
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                self.dismiss(animated: true) {
                    guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
                    let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TMLoginViewController")
                    appDel.window?.rootViewController = rootController
                }
            })
            alert.showInfo("Sair", subTitle: "Tem certeza que deseja sair?", closeButtonTitle: "Cancelar")
        }else{
            alert.addButton("Sair", action: {
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                
                self.dismiss(animated: true) {
                    guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
                    let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TMLoginViewController")
                    appDel.window?.rootViewController = rootController
                }
            })
            alert.showInfo(self.alertLogoutTitle, subTitle: self.alertLogoutDescription, closeButtonTitle: "Cancelar")
        }
    }
    
    @IBAction func openComoUsar(_ sender: UIButton) {
        let stringUrl:String?
        if(self.urlHowUse == ""){
            stringUrl = "https://www.mobilitee.com.br/itau/como-usar/"
        }else {
            stringUrl =  self.urlHowUse
        }
        if let url = URL(string: stringUrl!){
            if(UIApplication.shared.canOpenURL(url)){
                UIApplication.shared.open(url, options: [:], completionHandler: { (result) in
                })
            }
        }
    }
    
    @IBAction func openPoliticasDeUso(_ sender: UIButton) {
        let stringUrl:String?
        if(self.urlHowUse == ""){
            stringUrl = "https://mobilitee.com.br/itau/termos-de-uso/"
        }else {
            stringUrl =  self.urlTermsOfUse
        }
        if let url = URL(string: stringUrl!){
            if(UIApplication.shared.canOpenURL(url)){
                UIApplication.shared.open(url, options: [:], completionHandler: { (result) in
                })
            }
        }
    }
 }
 
 extension MBMenuLateralViewController : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
 }
 
 // Depreciado
 /* @IBAction func contactUs(_ sender: UIButton) {
  if(MFMailComposeViewController.canSendMail()){
  let mailComposeController = MFMailComposeViewController()
  mailComposeController.setToRecipients(["contato@mobilitee.com.br"])
  mailComposeController.setSubject("Suporte Mobilitee")
  mailComposeController.mailComposeDelegate = self
  self.present(mailComposeController, animated: true, completion: nil)
  }
  }*/
