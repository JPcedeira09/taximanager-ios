 //
//  TMMenuLateralViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 26/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import SCLAlertView

class TMMenuLateralViewController: UIViewController {

    @IBOutlet weak var labelNome: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nome = MBUser.currentUser?.firstName
        let sobrenome = MBUser.currentUser?.lastName
        
        
        
        self.labelNome.text = nome! + " " + sobrenome!
        // Do any additional setup after loading the view.
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
                    
                    print("Funfou?  \(result)" )
                })
            }
            
        }
        
        
        
    }
    @IBAction func openPoliticasDeUso(_ sender: UIButton) {
     
        let stringUrl = "https://s3-sa-east-1.amazonaws.com/mobilitee/Termo+de+Uso.html"
        
        if let url = URL(string: stringUrl){
            
            if(UIApplication.shared.canOpenURL(url)){
                
                UIApplication.shared.open(url, options: [:], completionHandler: { (result) in
                    
                    print("Funfou?  \(result)" )
                })
            }
            
        }
    }
    
    
}
