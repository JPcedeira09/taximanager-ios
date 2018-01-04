//
//  MBSobreOAppViewController.swift
//  TaxiManager
//
//  Created by Joao Paulo on 04/01/18.
//  Copyright © 2018 Taxi Manager. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftSpinner
import SCLAlertView
import FirebaseRemoteConfig

class MBSobreOAppViewController: UIViewController , CLLocationManagerDelegate{
    
    
    // IB Properties.
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
    
    // Properties
    var dados_do_login:String = ""
    var username:String = ""
    var empresa:String = ""
    var data:String = ""
    var locationManager = CLLocationManager()

    var longitude = 0.0
    var latitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        atualizarData()
        getLocation()
        self.btn_enviar.layer.cornerRadius = 3
        self.versaoDoApp.text = "Mobilitee - \(Bundle.main.releaseVersionNumberPretty)"
        self.funcional_empresa_numero.text = "\((MBUser.currentUser?.username)!) - \((MBUser.currentUser?.companyId)!)"
        self.informacoes_device.text = "Apple - \(UIDevice.current.modelName) - \( UIDevice.current.systemVersion)"
        self.informcaoMemorias.text = "\(DiskStatus.usedDiskSpace) - \(DiskStatus.freeDiskSpace)"
        self.UDID.text = "\(UIDevice.current.identifierForVendor!.uuidString)"
        self.data_hora_cidade.text = "\(self.data)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Methods.
    func atualizarData (){
        let dataAtual = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        dateFormatter.dateStyle = .full
        self.data = dateFormatter.string(from: dataAtual)
    }
    
    func getLocation(){
        let location = self.locationManager.location!
        if(location != nil){
            self.longitude = location.coordinate.longitude
            self.latitude = location.coordinate.latitude
            self.latitude_longitude.text = "\(self.latitude) , \(self.longitude)"
        }else{
            self.latitude_longitude.text = "sem localização do usuario"
        }
    }
    
    // IB Methods.
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func avalie_nos(_ sender: UIButton) {
    }
    
    @IBAction func enviar(_ sender: UIButton) {
    }
    
    
}
