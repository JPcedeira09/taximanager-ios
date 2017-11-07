//
//  TMBuscaEnderecoViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 31/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import GooglePlaces

class TMBuscaEnderecoViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var txtFieldBuscaEndereco: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Propriedades
    var fetcher = GMSAutocompleteFetcher()
    var arrayPredicoes = [GMSAutocompletePrediction]()
    var arrayRecentes = [[String:Any]]()
    var arrayPois = [[String:Any]]()
    var arrayFavoritos = [[String:Any]]()
    
    var selecionouEndereco: ((_ dicionario: [String : Any]) -> Void)?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let userDefaults = UserDefaults.standard
        
        if let arrayRecentes = userDefaults.value(forKey: "arrayRecentes"){
            self.arrayRecentes = arrayRecentes as! [[String : Any]]
        }

        if let arrayPois = userDefaults.value(forKey: "arrayPois"){
            self.arrayPois = arrayPois as! [[String : Any]]
        }
        
        if let arrayFavoritos = userDefaults.value(forKey: "arrayFavoritos"){
            self.arrayFavoritos = arrayFavoritos as! [[String : Any]]
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.fetcher.delegate = self
        self.txtFieldBuscaEndereco.delegate = self
        
        
        self.tableView.register(UINib(nibName: "TMCustomTableViewHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "tmHeaderCell")
        
        self.tableView.register(UINib(nibName: "TMBuscaEnderecoCell", bundle: nil), forCellReuseIdentifier: "tmBuscaEnderecoCell")
    }
    
    //MARK: - Metodos
    
    @IBAction func fechar(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        
        fetcher.sourceTextHasChanged(sender.text!)
    }
}

extension TMBuscaEnderecoViewController : GMSAutocompleteFetcherDelegate{
    func didFailAutocompleteWithError(_ error: Error) {
        
        print(error.localizedDescription)
    }
    
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        self.arrayPredicoes = predictions;
        self.tableView.reloadData()
        
    }
    
    
    
}

extension TMBuscaEnderecoViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tmBuscaEnderecoCell", for: indexPath) as! TMBuscaEnderecoCell
        
        switch indexPath.section {
        case 0:
            let predicao = self.arrayPredicoes[indexPath.row]
            cell.labelEndereco.attributedText = predicao.attributedFullText
        case 1:
            let recente = self.arrayRecentes[indexPath.row]
            cell.labelEndereco.text = recente["address"] as? String
        case 2:
            let favorito = self.arrayFavoritos[indexPath.row]
            cell.labelEndereco.text = favorito["name"] as? String
        case 3:
            let poi = self.arrayPois[indexPath.row]
            cell.labelEndereco.text = poi["name"] as? String
        default:
            cell.labelEndereco.text = ""
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return self.arrayPredicoes.count
        case 1:
            return self.arrayRecentes.count
        case 2:
            return self.arrayFavoritos.count
        case 3:
            return self.arrayPois.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tmHeaderCell") as! TMCustomTableViewHeaderTableViewCell
        
        switch section {
        case 0:
            cell.imgViewLogo.image = nil
            cell.labelTitulo.text = "Resultado Pesquisa"
        case 1:
            cell.imgViewLogo.image = #imageLiteral(resourceName: "icon_recente")
            cell.labelTitulo.text = "Recentes"
        case 2:
            cell.imgViewLogo.image = #imageLiteral(resourceName: "icon_favoritos")
            cell.labelTitulo.text = "Favoritos"
        case 3:
            cell.imgViewLogo.image = #imageLiteral(resourceName: "icon_poi")
            cell.labelTitulo.text = "Pontos de Interesse"
            
        default:
            cell.imgViewLogo.image = nil
            cell.labelTitulo.text = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            self.resolverDidSelectPesquisa()
        case 1:
            self.resolverDidSelectRecente()
        case 2:
            self.resolverDidSelectFavorito()

        case 3:
            self.resolverDidSelectPoi()

//            self.dismiss(animated: true, completion: nil)
            
        default:
            print("defaults")
        }
        
        self.dismiss(animated: true)
        
    }
}

extension TMBuscaEnderecoViewController : UITextFieldDelegate{
        
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            textField.resignFirstResponder()
            return true
        }
        
}

extension TMBuscaEnderecoViewController{
    
    
    func resolverDidSelectPesquisa(){
        
        let predicao = self.arrayPredicoes[tableView.indexPathForSelectedRow!.row]
        let gmsPlaceCliente = GMSPlacesClient()
        gmsPlaceCliente.lookUpPlaceID(predicao.placeID!) { (place, error) in
            
            if let err = error {
                
                print(err.localizedDescription)
            }
            
            let geocoder = CLGeocoder()
            
            let localizacao = CLLocation(latitude: place!.coordinate.latitude, longitude: place!.coordinate.longitude)
            
            
            
            geocoder.reverseGeocodeLocation(localizacao, completionHandler: { (placemarks, error) in
                
                if (error == nil) {
                    var endereco = ""
                    if let plmarks = placemarks {
                        let firstLocation = plmarks[0]
                        
                        if let thoroughfare = firstLocation.thoroughfare{
                            
                            endereco += thoroughfare
                            
                            if let subThoroughfare = firstLocation.subThoroughfare{
                                
                                endereco += ", " + subThoroughfare
                            }
                        }
                        
                        var dictionaryAddress : [String: Any] = [:]
                        
                        dictionaryAddress.updateValue(Double(firstLocation.location!.coordinate.latitude), forKey: "lat")
                        dictionaryAddress.updateValue(Double(firstLocation.location!.coordinate.longitude), forKey: "lng")
                        dictionaryAddress.updateValue("\(firstLocation.postalCode!)", forKey: "zipcode")
                        dictionaryAddress.updateValue("\(firstLocation.locality!)", forKey: "city")
                        dictionaryAddress.updateValue("\(firstLocation.administrativeArea!)", forKey: "state")
                        dictionaryAddress.updateValue(place?.formattedAddress ?? "", forKey: "address")
                        
                        self.selecionouEndereco?(dictionaryAddress)
                        
                        self.arrayRecentes.append(dictionaryAddress)
                        
                        UserDefaults.standard.setValue(self.arrayRecentes, forKey: "arrayRecentes")
                        UserDefaults.standard.synchronize()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                else {
                    // An error occurred during geocoding.
                    print("Não deu certo")
                    
                }
            })
        }
    }
    
    func resolverDidSelectRecente(){
        
        self.selecionouEndereco?(self.arrayRecentes[self.tableView.indexPathForSelectedRow!.row])
    }
    
    func resolverDidSelectFavorito(){
        
        self.selecionouEndereco?(self.arrayFavoritos[self.tableView.indexPathForSelectedRow!.row])
    }
    
    func resolverDidSelectPoi(){
        
         self.selecionouEndereco?(self.arrayPois[self.tableView.indexPathForSelectedRow!.row])
        
    }
    
}
