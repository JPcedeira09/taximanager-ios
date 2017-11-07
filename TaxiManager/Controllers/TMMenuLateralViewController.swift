//
//  TMMenuLateralViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 26/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit

class TMMenuLateralViewController: UIViewController {

    @IBOutlet weak var labelNome: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nome = UserDefaults.standard.value(forKey: "nomeUsuario") as? String
        let sobrenome = UserDefaults.standard.value(forKey: "sobrenomeUsuario") as? String
        
        self.labelNome.text = nome! + " " + sobrenome!
        // Do any additional setup after loading the view.
    }

    @IBAction func sair(_ sender: UIButton) {
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        self.dismiss(animated: true) {
            guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
            let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TMLoginViewController")
            appDel.window?.rootViewController = rootController
        }
    }
    
}
