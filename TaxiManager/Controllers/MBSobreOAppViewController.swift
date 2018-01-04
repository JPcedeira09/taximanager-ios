//
//  MBSobreOAppViewController.swift
//  TaxiManager
//
//  Created by Joao Paulo on 04/01/18.
//  Copyright © 2018 Taxi Manager. All rights reserved.
//

import UIKit

class MBSobreOAppViewController: UIViewController {
    
    @IBOutlet weak var textRemoteConfig: UITextView!
    @IBOutlet weak var versaoDoApp: UILabel!
    @IBOutlet weak var funcional_empresa_numero: UILabel!
    @IBOutlet weak var informcaoMemorias: UILabel!
    @IBOutlet weak var UDID: UILabel!
    @IBOutlet weak var data_hora_cidade: UILabel!
    @IBOutlet weak var latitude_longitude: UILabel!
    @IBOutlet weak var conexao_do_cliente: UILabel!
    @IBOutlet weak var informacoes_device: UILabel!
    @IBOutlet weak var btn_enviar: UIButton!
    var dados_do_login:String  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_enviar.layer.cornerRadius = 3
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func avalie_nos(_ sender: UIButton) {
    }
    
    @IBAction func enviar(_ sender: UIButton) {
    }
    
    
}
