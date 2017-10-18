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


class TelaBuscaViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var textFieldPontoOrigem: UITextField!
    @IBOutlet weak var textFieldPontoDestino: UITextField!
    @IBOutlet weak var labelDistancia: UILabel!
    @IBOutlet weak var labelDuracao: UILabel!
    @IBOutlet weak var tableViewResultado: UITableView!
    
    
    //MARK: - Propriedades
    var resumoBusca : ResumoBusca?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupHeader()
        
        self.tableViewResultado.delegate = self
        self.tableViewResultado.dataSource = self
        
        self.tableViewResultado.register(UINib(nibName: "TMResultadoBuscaCell", bundle: nil), forCellReuseIdentifier: "tmResultadoBusca")
        
        
        let distanciaFormatada = String(format: "%.1f km", Float((self.resumoBusca?.distanciaCorrida)!) / 1000.0)
//        print(self.resumoBusca?.arrayCorridas)
//        self.labelDistancia.text =  "\(Float((self.resumoBusca?.distanciaCorrida)!) / 1000.0) km"
        self.labelDistancia.text = distanciaFormatada
        self.labelDuracao.text =  "\(self.resumoBusca?.duracaoCorrida ?? 00) min"
        self.textFieldPontoOrigem.text = self.resumoBusca?.enderecoOrigem
        self.textFieldPontoDestino.text = self.resumoBusca?.enderecoDestino
        
    
    }
    
    //MARK: - Metodos
    
    func setupHeader(){
        
        //Setup imagem taximanager
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo_header"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
        //setup botao perfil
        let btnPerfil = UIButton(type: .custom)
        btnPerfil.setImage(#imageLiteral(resourceName: "icon_perfil_header"), for: .normal)
        btnPerfil.contentHorizontalAlignment = .center
        let barButtonItem2 = UIBarButtonItem(customView: btnPerfil)
        self.navigationItem.rightBarButtonItem = barButtonItem2
    }

}

extension TelaBuscaViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.resumoBusca!.arrayCorridas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "tmResultadoBusca", for: indexPath) as! TMResultadoBuscaCell
        
        let corrida = self.resumoBusca!.arrayCorridas[indexPath.row]
        cell.labelNome.text = corrida.name
        cell.labelPreco.text = corrida.price
        cell.labelEspera.text = "\(corrida.waitingTime) min"
//        cell.imgViewLogo.image = UIImage()
        
        if(corrida.id == 3){
            cell.imgViewLogo.image = #imageLiteral(resourceName: "icon99")
        }else{
            if let urlLogo = URL(string: corrida.urlLogo){
                let task = URLSession.shared.dataTask(with: urlLogo) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async() {
                        cell.imgViewLogo.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
        
        
        
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let corrida = self.resumoBusca!.arrayCorridas[indexPath.row]
    
        guard let urlApp = URL(string: corrida.url) else{
            
            return
        }
        
        if(UIApplication.shared.canOpenURL(urlApp)){
            
            UIApplication.shared.open(urlApp)
        }
    }
    
}
