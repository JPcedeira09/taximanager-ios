//
//  TMBuscaEnderecoViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 31/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import GooglePlaces
import Contacts
import SwiftSpinner

class MBBuscaEnderecoViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var txtFieldBuscaEndereco: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // Texto para saber qual o placeholder do txtFieldBuscaEndereco
    var textoDestination: String?
    
    // status para saber qual o fluxo que exibe a MBBuscaEnderecoViewController 0 para fluxo da tela inicial, 1 para fluxo tela de adicionar favoritos.
    var destinationViewController: Int?
    
    //MARK: - Propriedades
    var fetcher = GMSAutocompleteFetcher()
    var arrayPredicoes = [GMSAutocompletePrediction]()
    var arrayRecentes = [MBAddress]()
    var arrayPois = [MBPoi]()
    var arrayFavoritos = [MBBookmark]()
    var selecionouEndereco: ((_ dicionario: MBLocation) -> Void)?
    var expandedSections : NSMutableSet = [0]
    
    var timer : Timer!
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---------- iNFO placeholder:\(textoDestination)-------------")
        self.txtFieldBuscaEndereco.placeholder = textoDestination
        
        // Do any additional setup after loading the view.
        if let recents = MBUser.currentUser?.recents{
            self.arrayRecentes = recents
        }
        
        if let mbPois = MBUser.currentUser?.pois{
            self.arrayPois = mbPois
        }
        
        if let arrayFavoritos = MBUser.currentUser?.bookmarks{
            self.arrayFavoritos = arrayFavoritos
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.fetcher.delegate = self
        self.txtFieldBuscaEndereco.delegate = self
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.tableView.register(UINib(nibName: "TMCustomTableViewHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "tmHeaderCell")
        
        self.tableView.register(UINib(nibName: "TMBuscaEnderecoCell", bundle: nil), forCellReuseIdentifier: "tmBuscaEnderecoCell")
        
        self.txtFieldBuscaEndereco.becomeFirstResponder()
        
    }
    
    //MARK: - Metodos
    
    override var canBecomeFirstResponder : Bool{
        
        return true
    }
    @IBAction func fechar(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        
        if self.timer != nil {
            
            self.timer.invalidate()
        }
        if let text = sender.text {
            
            if text.count >= 5 {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (timer) in
                    self.fetcher.sourceTextHasChanged(text)
                    timer.invalidate()
                })
            }
        }
    }
        
    @objc func sectionTapped(_ sender: UIButton) {
        
        self.becomeFirstResponder()
        let section = sender.tag
        let shouldExpand = !expandedSections.contains(section)
        if (shouldExpand) {
            // usar o remove() para fechar as sections aberta
            //expandedSections.remove()
            expandedSections.add(section)
        } else {
            expandedSections.remove(section)
        }
        self.tableView.reloadData()
    }
}

extension MBBuscaEnderecoViewController : GMSAutocompleteFetcherDelegate{
    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.arrayPredicoes = predictions;
        self.tableView.reloadData()
    }
}

extension MBBuscaEnderecoViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tmBuscaEnderecoCell", for: indexPath) as! TMBuscaEnderecoCell
        
        switch destinationViewController! {
        case 0:
            switch indexPath.section {
            case 0:
                let predicao = self.arrayPredicoes[indexPath.row]
                cell.labelEndereco.attributedText = predicao.attributedFullText
            case 1:
                let recente = self.arrayRecentes[indexPath.row]
                cell.labelEndereco.text = recente.address
            case 2:
                let poi = self.arrayPois[indexPath.row]
                cell.labelEndereco.text = poi.mainText
            default:
                cell.labelEndereco.text = ""
            }
        case 1:
            switch indexPath.section {
            case 0:
                let predicao = self.arrayPredicoes[indexPath.row]
                cell.labelEndereco.attributedText = predicao.attributedFullText
            case 1:
                let recente = self.arrayRecentes[indexPath.row]
                cell.labelEndereco.text = recente.address
            case 2:
                let favorito = self.arrayFavoritos[indexPath.row]
                cell.labelEndereco.text = favorito.mainText
            case 3:
                let poi = self.arrayPois[indexPath.row]
                cell.labelEndereco.text = poi.mainText
            default:
                cell.labelEndereco.text = ""
            }
        default:
            switch indexPath.section {
            case 0:
                let predicao = self.arrayPredicoes[indexPath.row]
                cell.labelEndereco.attributedText = predicao.attributedFullText
            case 1:
                let recente = self.arrayRecentes[indexPath.row]
                cell.labelEndereco.text = recente.address
            case 2:
                let favorito = self.arrayFavoritos[indexPath.row]
                cell.labelEndereco.text = favorito.mainText
            case 3:
                let poi = self.arrayPois[indexPath.row]
                cell.labelEndereco.text = poi.mainText
            default:
                cell.labelEndereco.text = ""
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(expandedSections.contains(section)) {
            switch destinationViewController! {
            case 0:
            switch section {
            case 0:
                return self.arrayPredicoes.count
            case 1:
                return self.arrayRecentes.count <= 10 ? self.arrayRecentes.count : 10
            case 2:
                return self.arrayPois.count
            default:
                return 0
            }
            case 1:
                switch section {
                case 0:
                    return self.arrayPredicoes.count
                case 1:
                    return self.arrayRecentes.count <= 10 ? self.arrayRecentes.count : 10
                case 2:
                    return self.arrayFavoritos.count
                case 3:
                    return self.arrayPois.count
                default:
                    return 0
                }
            default:
                switch section {
                case 0:
                    return self.arrayPredicoes.count
                case 1:
                    return self.arrayRecentes.count <= 10 ? self.arrayRecentes.count : 10
                case 2:
                    return self.arrayFavoritos.count
                case 3:
                    return self.arrayPois.count
                default:
                    return 0
                }
            }
        }else{
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch destinationViewController! {
        case 0:
            return 3
        case 1:
            return 4
        default:
            return 4
        }
        }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tmHeaderCell") as! TMCustomTableViewHeaderTableViewCell
        switch destinationViewController! {
        case 0:
            switch section {
            case 0:
                cell.imgViewLogo.image = nil
                cell.labelTitulo.text = "Resultado Pesquisa"
            case 1:
                cell.imgViewLogo.image = #imageLiteral(resourceName: "icon_recente")
                cell.labelTitulo.text = "Recentes"
            case 2:
                cell.imgViewLogo.image = #imageLiteral(resourceName: "icon_poi")
                cell.labelTitulo.text = "Pontos de Interesse"
            default:
                cell.imgViewLogo.image = nil
                cell.labelTitulo.text = ""
            }
        case 1:
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
        default:
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
        }
        
        if(section != 0){
            
            if (expandedSections.contains(section)) {
                cell.imgViewSeta.image = #imageLiteral(resourceName: "icon_seta_baixo")
            }else{
                cell.imgViewSeta.image = #imageLiteral(resourceName: "icon_seta_direita")
            }
            cell.btnSection.addTarget(self, action: #selector(sectionTapped), for: .touchUpInside)
            cell.btnSection.tag = section
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch destinationViewController! {
        case 0 :
            switch indexPath.section {
            case 0:
                self.resolverDidSelectPesquisa()
            case 1:
                self.resolverDidSelectRecente()
            case 2:
                self.resolverDidSelectPoi()
            default:
                print("defaults")
            }
        case 1:
            switch indexPath.section {
            case 0:
                self.resolverDidSelectPesquisa()
            case 1:
                self.resolverDidSelectRecente()
            case 2:
                self.resolverDidSelectFavorito()
            case 3:
                self.resolverDidSelectPoi()
            default:
                print("defaults")
            }
        default:
            switch indexPath.section {
            case 0:
                self.resolverDidSelectPesquisa()
            case 1:
                self.resolverDidSelectRecente()
            case 2:
                self.resolverDidSelectFavorito()
            case 3:
                self.resolverDidSelectPoi()
            default:
                print("defaults")
            }
        }
        self.dismiss(animated: true)
    }
}

extension MBBuscaEnderecoViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension MBBuscaEnderecoViewController{
    
    func resolverDidSelectPesquisa(){
        
        let predicao = self.arrayPredicoes[tableView.indexPathForSelectedRow!.row]
        
        let gmsPlaceCliente = GMSPlacesClient()
        gmsPlaceCliente.lookUpPlaceID(predicao.placeID!) { (place, error) in
            
            if let err = error {
                print(err.localizedDescription)
            }
            
            let geocoder = CLGeocoder()
            
            let localizacao = CLLocation(latitude: place!.coordinate.latitude, longitude: place!.coordinate.longitude)
            
            var number = "0"

            for component in place!.addressComponents!{
                print(component.type + " - " + component.name)
                if(component.type == "street_number"){
                    number = component.name
                }
            }

            geocoder.reverseGeocodeLocation(localizacao, completionHandler: { (placemarks, error) in
                
                if (error == nil) {
                    var endereco = "00000000"
                    if let plmarks = placemarks {
                        let firstLocation = plmarks[0]
     
                        var postalCode = ""
                        if let zip = firstLocation.addressDictionary?["ZIP"] as? String{
                            
                            postalCode = zip
                        }
                        if let code = firstLocation.addressDictionary?["PostCodeExtension"] as? String{
                            
                            postalCode += code
                        }else{
                            postalCode += "000"
                        }
                        
                        if let thoroughfare = firstLocation.thoroughfare{
                            
                            endereco += thoroughfare
                            
                            if let subThoroughfare = firstLocation.subThoroughfare{
                                endereco += ", " + subThoroughfare
                            }
                        }
                        
                        let address = MBAddress(latitude: firstLocation.location!.coordinate.latitude, longitude: firstLocation.location!.coordinate.longitude, address: predicao.attributedFullText.string, district: firstLocation.subLocality ?? "", city: firstLocation.locality!, state: firstLocation.administrativeArea!, zipcode: postalCode, number: number )
                       
                        self.selecionouEndereco?(address)
                        self.arrayRecentes.append(address)
                        
                        do{
                            MBUser.currentUser?.recents = self.arrayRecentes
                            let userEncoded = try JSONEncoder().encode(MBUser.currentUser)
                            UserDefaults.standard.setValue(userEncoded, forKey: "user")
                            UserDefaults.standard.synchronize()
                        }catch{}

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
