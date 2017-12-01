//
//  TelaBuscaViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 08/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GooglePlaces
import Alamofire
import SCLAlertView
import FirebaseAnalytics


class TelaBuscaViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var textFieldPontoOrigem: UITextField!
    @IBOutlet weak var textFieldPontoDestino: UITextField!
    
    
    @IBOutlet weak var labelStartAddress: UILabel!
    @IBOutlet weak var labelEndAddress: UILabel!
    @IBOutlet weak var labelDistancia: UILabel!
    @IBOutlet weak var labelDuracao: UILabel!
    @IBOutlet weak var tableViewResultado: UITableView!
    
    //MARK: - Propriedades
//    var resumoBusca : ResumoBusca?
    var searchResult : MBSearchResult?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupHeader()
        self.tableViewResultado.delegate = self
        self.tableViewResultado.dataSource = self
        
        self.tableViewResultado.register(UINib(nibName: "TMResultadoBuscaCell", bundle: nil), forCellReuseIdentifier: "tmResultadoBusca")
        
        let distanciaFormatada = String(format: "%.1f km", Float((self.searchResult?.distance)!) / 1000.0)
        self.labelDistancia.text = distanciaFormatada
        self.labelDuracao.text =  "\(self.searchResult?.duration ?? 00) min"
        self.labelStartAddress.text = self.searchResult?.startAddress.address
        self.labelEndAddress.text = self.searchResult?.endAddress.address
        

        
    }
    
    //MARK: - Metodos
    
    func setupHeader(){
        
        //Setup imagem taximanager
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logotipo_fundo_preto.png"))
        imageView.contentMode = .scaleAspectFit
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        navigationItem.titleView = titleView
    }
    
    func checarAcoesCorrida (corrida : MBRide){
        
        let application = UIApplication.shared
        
        if let urlDeeplinkString = corrida.urlDeeplink,
           let urlDeeplink = URL(string: urlDeeplinkString),
            application.canOpenURL(urlDeeplink)
           {
            
            Analytics.logEvent("openDeepLink", parameters: ["player" : corrida.name,
                                                            "uuid" : corrida.uuid])
            application.open(urlDeeplink)
        
        }else{
            let alert = SCLAlertView()
            
            if let urlStoreString = corrida.urlStore, let urlStore = URL(string: urlStoreString){
                
                alert.addButton("Instalar agora", action: {
                    Analytics.logEvent("openStore", parameters: ["player" : corrida.name,
                                                                    "uuid" : corrida.uuid])
                    application.open(urlStore)
                })
            }
            if let urlWebString = corrida.urlWeb,
                let urlWeb = URL(string: urlWebString){
                
                alert.addButton("Solicitar carro", action: {
                    Analytics.logEvent("openWeb", parameters: ["player" : corrida.name,
                                                                    "uuid" : corrida.uuid])
                    application.open(urlWeb)
                })
            }
            
            alert.showInfo("Você não possui o aplicativo instalado", subTitle: "", closeButtonTitle: "Cancelar", colorStyle: 0x242424)
            
        }
        
        
        
    }
}

extension TelaBuscaViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResult!.travels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tmResultadoBusca", for: indexPath) as! TMResultadoBuscaCell
        
        let corrida = self.searchResult!.travels[indexPath.row]
        
        cell.labelNome.text = corrida.modality.name
        cell.labelNomeModalidade.text = corrida.name
        cell.labelPreco.text = corrida.price
        cell.labelEspera.text = "\(corrida.waitingTime ?? 4) min"
        cell.imgViewLogo.image = UIImage()
        
        if let urlLogo = URL(string: corrida.urlLogo!) {
            let task = URLSession.shared.dataTask(with: urlLogo) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    cell.imgViewLogo.image = UIImage(data: data)
                }
            }
            task.resume()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let corrida = self.searchResult!.travels[indexPath.row]
        
        print(corrida)
        
        self.checarAcoesCorrida(corrida: corrida)
        
    }
    
}

