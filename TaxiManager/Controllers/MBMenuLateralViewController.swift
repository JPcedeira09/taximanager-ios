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
    
    
    var stringUrl:String?

    func setupRemoteConfigDefaults(){
        let defaultsValuesComoUsar = [
            "terms_of_use":"Como usar" as NSObject,
            "page_terms_of_use":"Políticas de uso" as NSObject]
        RemoteConfig.remoteConfig().setDefaults(defaultsValuesComoUsar)
    }
    func updateViewWithValues(){
        let buttonLabel = RemoteConfig.remoteConfig().configValue(forKey: "terms_of_use").stringValue ?? ""
        politicasDeUso.setTitle(buttonLabel, for: .normal)
             let urlRemote = RemoteConfig.remoteConfig().configValue(forKey: "page_terms_of_use").stringValue ?? ""
        print("INFO BUTTON REMOTE CONFIG:\(urlRemote)")

        stringUrl = urlRemote
        print("INFO URL REMOTE CONFIG:\(stringUrl)")
    }
    
    func fetchRemoteConfig(){
        // FIXE: Remove this before we go into productions!
        let debugSettings = RemoteConfigSettings(developerModeEnabled: true)
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { (status, error) in
            guard error == nil else {
                print("INFO: Error fetching values- \(error)")
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
        
        alert.showInfo("Sair", subTitle: "Tem certeza que deseja sair?", closeButtonTitle: "Cancelar")
    }
    
    @IBAction func openComoUsar(_ sender: UIButton) {
        
        let stringUrl =  "https://www.mobilitee.com.br/itau/como-usar/"
        
        if let url = URL(string: stringUrl){
            
            if(UIApplication.shared.canOpenURL(url)){
                
                UIApplication.shared.open(url, options: [:], completionHandler: { (result) in
                    
                })
            }
        }
    }
    
    @IBAction func openPoliticasDeUso(_ sender: UIButton) {
        
        let stringUrl = self.stringUrl ?? "https://s3-sa-east-1.amazonaws.com/mobilitee/Termo+de+Uso.html"
        
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
