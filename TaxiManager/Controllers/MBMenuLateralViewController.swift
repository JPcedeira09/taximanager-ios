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
    
    
    var urlTermsOfUse:String?
    var urlHowUse:String?
    var alertLogoutTitle:String?
    var alertLogoutDescription:String?
    
    func setupRemoteConfigDefaults(){
        let defaultsValuesComoUsar = [
            "terms_of_use":"Como usar" as NSObject,
            "page_terms_of_use":"Políticas de uso" as NSObject]
        RemoteConfig.remoteConfig().setDefaults(defaultsValuesComoUsar)
    }
    func updateViewWithValues(){
        //Remote Config button terms of use.
        let buttonTerms = RemoteConfig.remoteConfig().configValue(forKey: "button_terms_of_use").stringValue ?? ""
        politicasDeUso.setTitle(buttonTerms, for: .normal)
        print("iNFO button terms of use:\(buttonTerms)")

        //Remote config url terms of use
        let urlTerms = RemoteConfig.remoteConfig().configValue(forKey: "url_terms_of_use").stringValue ?? ""
        urlTermsOfUse = urlTerms
        print("iNFO url terms of use remote config:\(urlTermsOfUse ?? "urls")")
        
        //Remote config button how use.
        let buttonHow = RemoteConfig.remoteConfig().configValue(forKey: "button_how_use").stringValue ?? ""
        comoUsarButton.setTitle(buttonHow, for: .normal)
        print("iNFO button how use:\(buttonHow)")
        
        //Remote config url how use.
        let urlUse = RemoteConfig.remoteConfig().configValue(forKey: "urls_how_use").stringValue ?? ""
        urlHowUse = urlUse
        print("iNFO url how use remote config:\(urlHowUse ?? "urls")")
        
        //Remote config logout Alert Title.
        let alertTitleLogout = RemoteConfig.remoteConfig().configValue(forKey: "logout_alert_title").stringValue ?? ""
        alertLogoutTitle = alertTitleLogout
        print("iNFO alert logout title remote config:\(alertLogoutTitle ?? "title")")
        
        //Remote config url how use.
        let alertDescriptionLogout = RemoteConfig.remoteConfig().configValue(forKey: "logout_alert_description").stringValue ?? ""
        alertLogoutDescription = alertDescriptionLogout
        print("iNFO alert logout description remote config:\(alertLogoutDescription ?? "description")")
    }
    
    func fetchRemoteConfig(){
        // FIXE: Remove this before we go into productions!
        let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { (status, error) in
            guard error == nil else {
                print("INFO: Error fetching values- \(error?.localizedDescription ?? "erro!")")
                return
            }
            
            print("INFO: Firebase Remote Config its ok")
            RemoteConfig.remoteConfig().activateFetched()
            self.updateViewWithValues()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRemoteConfigDefaults()
        fetchRemoteConfig()
        
        let nome = MBUser.currentUser?.firstName
        let sobrenome = MBUser.currentUser?.lastName
        
        self.labelNome.text = nome! + " " + sobrenome!
        self.btnVersion.setTitle(Bundle.main.releaseVersionNumberPretty, for: .normal)
    }
    
    @IBAction func sair(_ sender: UIButton) {
        
        let alert = SCLAlertView()
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
        if(self.alertLogoutTitle! == "" || self.alertLogoutDescription! == ""){
            alert.showInfo("Sair", subTitle: "Tem certeza que deseja sair?", closeButtonTitle: "Cancelar")
        }else{
            alert.showInfo(self.alertLogoutTitle!, subTitle: self.alertLogoutDescription!, closeButtonTitle: "Cancelar")
        }
    }
    
    @IBAction func openComoUsar(_ sender: UIButton) {
        
        let stringUrl =  self.urlHowUse ?? "https://www.mobilitee.com.br/itau/como-usar/"
        if let url = URL(string: stringUrl){
            if(UIApplication.shared.canOpenURL(url)){
                UIApplication.shared.open(url, options: [:], completionHandler: { (result) in
                })
            }
        }
    }
    
    @IBAction func openPoliticasDeUso(_ sender: UIButton) {
        
        let stringUrl = self.urlTermsOfUse ?? "https://s3-sa-east-1.amazonaws.com/mobilitee/Termo+de+Uso.html"
        if let url = URL(string: stringUrl){
            if(UIApplication.shared.canOpenURL(url)){
                UIApplication.shared.open(url, options: [:], completionHandler: { (result) in
                })
            }
        }
    }
    
    @IBAction func contactUs(_ sender: UIButton) {
        
        if(MFMailComposeViewController.canSendMail()){
            let mailComposeController = MFMailComposeViewController()
            mailComposeController.setToRecipients(["contato@mobilitee.com.br"])
            mailComposeController.setSubject("Suporte Mobilitee")
            mailComposeController.mailComposeDelegate = self
            self.present(mailComposeController, animated: true, completion: nil)
        }
    }
 }
 
 extension MBMenuLateralViewController : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
 }
