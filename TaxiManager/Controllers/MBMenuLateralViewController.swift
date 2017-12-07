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
class MBMenuLateralViewController: UIViewController {

    @IBOutlet weak var labelNome: UILabel!
    @IBOutlet weak var btnVersion: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let stringUrl = "https://www.mobilitee.com.br/itau/como-usar/"
        
        if let url = URL(string: stringUrl){
            
            if(UIApplication.shared.canOpenURL(url)){
                
                UIApplication.shared.open(url, options: [:], completionHandler: { (result) in
                    
                })
            }
            
        }
    }
    @IBAction func openPoliticasDeUso(_ sender: UIButton) {
     
        let stringUrl = "https://s3-sa-east-1.amazonaws.com/mobilitee/Termo+de+Uso.html"
        
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
