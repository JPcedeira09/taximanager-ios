//
//  ViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 06/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
//import GoogleMaps
import GooglePlaces
import MapKit
import CoreLocation
import Alamofire
import SwiftSpinner
import Contacts
import SCLAlertView
//Open Weather API
//fddaea8c38c5d8cee66a234b2f812baa
//api.openweathermap.org/data/2.5/weather?lat=35&lon=139

class TelaInicialViewController: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageViewPin: UIImageView!
    
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var textFieldEnderecoOrigem: UITextField!
    @IBOutlet weak var textFieldEnderecoDestino: UITextField!
    @IBOutlet weak var textFieldDestinoTopSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewOrigem: UIView!
    @IBOutlet weak var viewDestino: UIView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    //MARK: - Propriedades
    var locationManager = CLLocationManager()
    var mapaMoveuInicialmente = false
    let googlePlacesOrigem = GMSAutocompleteViewController()
    let googlePlacesDestino = GMSAutocompleteViewController()
    var dicOrigem : [String: Any] = [:]
    var dicDestino : [String: Any] = [:]
    var resumoBusca : ResumoBusca?
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Maps config
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        //CoreLocation
        self.pedirAutorizacaoLocalizacaoUsuario()
        
        //Textfield
        self.textFieldEnderecoOrigem.delegate = self
        self.textFieldEnderecoDestino.delegate = self
        
        //Delegate GMS
        self.googlePlacesOrigem.delegate = self
        self.googlePlacesDestino.delegate = self
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo_header"))
        imageView.contentMode = .scaleAspectFit
        
        navigationItem.titleView = imageView
        
        
        self.setupTextFieldOrigem()
        self.atualizarLabelData()
        
//        self.atualizarPois()
//        self.atualizarFavoritos()
//        self.atualizarHistorico()
        
//        self.updatePois()
        
        
    }
    
//    func updatePois(){
//        
//        MobiliteeProvider.api.request(.getPOIs) { (result) in
//           
//            switch result{
//                
//            case let .success(response):
//                if response.statusCode == 200{
//                    do{
//                        
//                        let mbPoi = try response.map([MBPoi].self, atKeyPath: "records")
//                        print(mbPoi)
//                        
//
//                        print("================DICIONARIO =============")
////                        let mbUser = MBUser(from: dictionary)
//                        
////                        let userEncoded = try JSONEncoder().encode(mbUser)
////                        UserDefaults.standard.set(userEncoded, forKey: "user")
//                        
////                        let defaults = UserDefaults.standard
////                        defaults.set(mbUser.id, forKey: "idUsuario")
////                        defaults.set(mbUser.companyId, forKey: "idEmpresa")
////                        defaults.set(mbUser.firstName, forKey: "nomeUsuario")
////                        defaults.set(mbUser.lastName, forKey: "sobrenomeUsuario")
////                        defaults.set(mbUser.employeeId, forKey: "employeeId")
////                        defaults.set(mbUser.token, forKey: "token")
////
////                        defaults.synchronize()
////
//                        
//                        
//                        
//                    }catch{
//                        
//                        print("caiu no catch")
//                    }
//                }
//            case let .failure(error):
//                
//                print(error.localizedDescription)
//            }
//        
//        }
//        
//    }
//    func atualizarPois(){
//        let url = "https://api.taximanager.com.br/v1/taximanager/companies/interestpoints"
//        let defaults = UserDefaults.standard
//        let headers : [String:String] = ["Authorization" : defaults.value(forKey: "token") as! String]
//        
//        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, headers: headers).responseJSON { (response) in
//            
//            if let err = response.error{
//                
//            }
//            
//            if(response.result.isSuccess){
//                
//                if let json = response.result.value as? [String : AnyObject]{
//                    
//                    if let records = json["records"] as? [[String:Any]]{
//                        
//                        
//                        var arrayPois : [[String: Any]] = []
//                        for record in records{
//                            
//                            var dictionary : [String: Any] = [:]
//                            
//                            
//                            //                        print(record)
//                            
//                            dictionary["lat"] = record["latitude"] as! Double
//                            dictionary["lng"] = record["longitude"] as! Double
//                            dictionary["zipcode"] = record["zipcode"] as! String
//                            dictionary["city"] = record["city"] as! String
//                            dictionary["state"] = record["state"] as! String
//                            dictionary["address"] = record["address"] as! String
//                            dictionary["name"] = record["mainText"] as! String
//                            
//                            //                        arrayPois.append(dictionary)
//                            arrayPois.insert(dictionary, at: 0)
//                        }
//                        
//                        defaults.setValue(arrayPois, forKey: "arrayPois")
//                        
//                    }
//                    
//                }
//            }
//            
//        }
//    }
//    
//    func atualizarFavoritos(){
//        let url = "https://api.taximanager.com.br/v1/taximanager/employees/bookmarks"
//        let defaults = UserDefaults.standard
//        let headers : [String:String] = ["Authorization" : defaults.value(forKey: "token") as! String]
//        
//        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, headers: headers).responseJSON { (response) in
//            
//            if let err = response.error{
//                
//            }
//            
//            if(response.result.isSuccess){
//                
//                if let json = response.result.value as? [String : AnyObject]{
//                    
//                    if let records = json["records"] as? [[String:Any]]{
//                        
//                        var arrayFavoritos : [[String: Any]] = []
//                        
//                        for record in records{
//                            
//                            var dictionary : [String: Any] = [:]
//                            
//                            dictionary["lat"] = record["latitude"] as! Double
//                            dictionary["lng"] = record["longitude"] as! Double
//                            dictionary["zipcode"] = record["zipcode"] as! String
//                            dictionary["city"] = record["city"] as! String
//                            dictionary["state"] = record["state"] as! String
//                            dictionary["address"] = record["address"] as! String
//                            dictionary["name"] = record["mainText"] as! String
//                            dictionary["id"] = record["id"] as! Double
//                            
//                            
//                            //                        arrayFavoritos.append(dictionary)
//                            arrayFavoritos.insert(dictionary, at: 0)
//                        }
//                        
//                        defaults.setValue(arrayFavoritos, forKey: "arrayFavoritos")
//                        
//                    }
//                    
//                }
//            }
//            
//        }
//    }
    
    
    func atualizarHistorico(){
        
        let defaults = UserDefaults.standard
        let headers : [String:String] = ["Authorization" : defaults.value(forKey: "token") as! String]
        var parameters : [String : AnyObject] = [:]
        
        let companyId = "\(defaults.value(forKey: "idEmpresa") as! NSNumber)"
//        parameters["companyid"] = defaults.value(forKey: "idEmpresa") as! NSNumber
        parameters["employeeId"] = defaults.value(forKey: "employeeId") as! NSNumber
        
        print("==================================")
        print(defaults.value(forKey: "idEmpresa") as! NSNumber)
        print(defaults.value(forKey: "employeeId") as! NSNumber)
        print("==================================")
        
        let url = "https://api.taximanager.com.br/v1/taximanager/companies/"+companyId+"/travels"
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: parameters, headers: headers).responseJSON { (response) in
            
            if let err = response.error{
                
            }
            
            if(response.result.isSuccess){
                
                if let json = response.result.value as? [String : AnyObject]{
                
                    if let records = json["records"] as? [[String:Any]] {
                        
                        
                        var arrayHistorico : [[String : Any]] = []
                        
                        for record in records {
                            
                            var registro : [String : Any] = [:]
                            var playerService = record["playerService"] as! [String : Any]
                            var player = playerService["player"] as! [String : Any]
                            var centroDeCustoObj = record["companyCostCentre"] as! [String : Any]
                            
                            registro["enderecoOrigem"] = record["startAddress"] as! String
                            registro["enderecoDestino"] = record["endAddress"] as! String
                            registro["id"] = record["id"] as! Int
                            registro["distancia"] = record["distance"] as! NSNumber
                            registro["valor"] = record["cost"] as! NSNumber
                            registro["categoriaPlayer"] = playerService["description"] as! String
                            registro["nomePlayer"] = player["name"] as! String
                            registro["centroDeCusto"] = centroDeCustoObj["name"] as! String
                            registro["projeto"] = record["project"] as? String
                            registro["justificativa"] = ""
                            registro["dataInicio"] = record["startDate"] as! String
                            registro["dataFim"] = record["endDate"] as! String
                            
                            
                            arrayHistorico.insert(registro, at: 0)
                            
                            
                            print(registro)
                        }
                        print("==================================")
                        
                        defaults.setValue(arrayHistorico, forKey: "arrayHistorico")
                        
                        
                        
                    }
                    
                    
                    
                }
                
            }
            
        }
    }
    
    @objc func localizarUsuario(){
        
        let location = self.locationManager.location!
        
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if (error == nil) {
                
                var endereco = ""
                if let plmarks = placemarks {
                    
                    let firstLocation = plmarks[0]
//                    firstLocation.addressDictionary["ZIP"] + firstLocation.addressDictionary["PostCodeExtension"]
                    
                    if let thoroughfare = firstLocation.thoroughfare{
                        endereco += thoroughfare
                        
                        if let subThoroughfare = firstLocation.subThoroughfare{
                            endereco += ", " + subThoroughfare
                        }
                    }
                    
                    self.textFieldEnderecoOrigem.text = endereco
                    self.mapView.setCenter(firstLocation.location!.coordinate, animated: true)
                    
                }
                
            }
            else {
                
                //Erro
            }
        })
        
    }
    
    
    @IBAction func btnProximoPasso(_ sender: UIButton) {
        
        if(self.textFieldEnderecoOrigem.text != "" && self.textFieldEnderecoDestino.text != ""){
            
            self.checarDistancia(origem: self.dicOrigem, destino: self.dicDestino)
            
            
        }else{
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5) {
                
                self.textFieldDestinoTopSpaceConstraint.constant = 8
                self.view.layoutIfNeeded()
                
                
            }
            sender.setTitle("Ver melhores opções", for: .normal)
        }
    }
    //MARK: - Navegação
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "segueTelaBusca"){
            
            let buscaViewController = segue.destination as! TelaBuscaViewController
            
            buscaViewController.resumoBusca = self.resumoBusca
        }
    }
    //MARK: - Métodos
    func pedirAutorizacaoLocalizacaoUsuario(){
        
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse){
            
            self.locationManager.requestWhenInUseAuthorization()
            
        }
        
        self.locationManager.delegate = self;
        self.locationManager.startUpdatingLocation()
    }
    
    func atualizarLabelData (){
        
        let dataAtual = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-BR")
        //        dateFormatter.dateFormat = "EEEE"
        dateFormatter.dateStyle = .full
        
        
        self.labelData.text = dateFormatter.string(from: dataAtual)
    }
    func checarDistancia(origem : [String : Any], destino : [String : Any]){
        
        SwiftSpinner.show("Verificando as melhores opções...")
        let urlRequest = "https://maps.googleapis.com/maps/api/distancematrix/json"
        let origins = "\(origem["latitude"]!)" + "," + "\(origem["longitude"]!)"
        let destinations = "\(destino["latitude"]!)" + "," + "\(destino["longitude"]!)"
        
        let parametros = ["key": "AIzaSyAL4jaoV5Sl42t2XXgOjDRV-vIMGCWBCPI" , "origins" : origins, "destinations": destinations]
        
        Alamofire.request(urlRequest, method: HTTPMethod.get, parameters: parametros).responseJSON { (response) in
            
            if(response.result.isSuccess){
                
                if let json = response.result.value as? [String : AnyObject]{
                    
                    let rows = json["rows"] as! Array<AnyObject>
                    
                    //                    print(rows)
                    let pre_elements = rows[0] as! [String : AnyObject]
                    let elements = pre_elements["elements"] as! [AnyObject]
                    let elemento = elements[0] as! [String : AnyObject]
                    
                    //Propriedades finais
                    let duracao = elemento["duration"] as! [String : AnyObject]
                    let distancia = elemento["distance"] as! [String : AnyObject]
                    //                    let status = elemento["status"] as! String
                    
                    let duracaoFormatada  = Int(duracao["text"]!.components(separatedBy: " ")[0])!
                    let distanciaFormatada = distancia["value"] as! Int
                    
                    
                    
                    self.checarPrecos(origem: self.dicOrigem, destino: self.dicDestino, device: [:], distancia: distanciaFormatada, duracao: duracaoFormatada)
                                        
//                                        print("Duracao", duracaoFormatada)
//                                        print("Distancia", distanciaFormatada)
                    
                }
            }
        }
    }
    
    func checarPrecos(origem : [String : Any], destino : [String : Any], device: [String : String], distancia : Int, duracao : Int){
        
        //passar user_id e company_id
        
        let idUsuario = UserDefaults.standard.value(forKey: "idUsuario") as! Int
        let idEmpresa = UserDefaults.standard.value(forKey: "idEmpresa") as! Int
        
        
        let parametros = ["device" : device, "start" : origem, "end" : destino, "distance" : distancia , "duration" : duracao, "company_id" : idEmpresa, "user_id" : idUsuario] as [String : Any]
        
        let url = URL(string: "http://estimate.taximanager.com.br/v1/estimates")!
        let autorizationKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNTAwMzM4MjU0fQ.B2Nch63Zu0IzJDepVTDXqq8ydbIVDiUmU6vV_7eQocw"
        do
        {
            
            
            let body = try JSONSerialization.data(withJSONObject: parametros)
            
            print("XXXXXXXXXXXXXXXXXXX")
            
            print(parametros)
            
            print("XXXXXXXXXXXXXXXXXXX")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(autorizationKey, forHTTPHeaderField: "Authorization")
            request.httpBody = body
            let session = URLSession.shared
            let task = session.dataTask(with: request){
                (data, response, error) in
                
                SwiftSpinner.hide()
                if(error == nil){
                    
                    
                    do{
                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                        
                        let origem = jsonData["start"] as! [String : AnyObject]
                        let destino = jsonData["end"] as! [String : AnyObject]
                        
                        guard let endOrigem = origem["address"] as! String? else {
                            print("falhou end origem")
                            return
                        }
                        
                        guard let endDestino = destino["address"] as! String? else {
                            print("falhou end destino")
                            return
                        }
                        
                        guard let records = jsonData["records"] as? [[String : AnyObject]] else {
                            
                            let alerta = SCLAlertView()
                            alerta.showInfo("Ops!", subTitle: "Não conseguimos encontrar motoristas para estes endereços.")
                            return
                        }
                        
                        var arrayCorridas : [Corrida] = []
                        
                        for record in records{
                            
                            var novaCorrida = Corrida()
                            
                            if let alertMessage = record["alert_message"] as? String{
                                novaCorrida.alertMessage = alertMessage
                            }
                            
                            if let id = record["id"] as? Int {
                                novaCorrida.id = id
                            }
                            if let name = record["name"] as? String{
                                
                                novaCorrida.name = name
                            }
                            
                            if let modality = record["modality"] as? [String : AnyObject]{
                                
                                if let name = modality["name"] as? String{
                                    
                                    novaCorrida.modalityName = name
                                }
                            }
                            
                            if let price = record["price"] as? String {
                                
                                novaCorrida.price = price
                            }
                            
                            if let waitingTime = record["waiting_time"] as? Int{
                                
                                novaCorrida.waitingTime = waitingTime
                            }
                            
                            if let urlDeepLinkString = record["url"] as? String{
                                
                                novaCorrida.urlDeeplink = URL(string: urlDeepLinkString)
                            }
                            
                            if let urlLogoString = record["url_logo"] as? String{
                                
                                novaCorrida.urlLogo = URL(string: urlLogoString)
                            }
                            
                            if let urlLojaString = record["url_loja_ios"] as? String{
                                
                                novaCorrida.urlLoja = URL(string: urlLojaString)
                            }
                            
                            if let urlWebString = record["url_web"] as? String{
                                
                                novaCorrida.urlWeb = URL(string: urlWebString)
                            }
                            
                            
                            arrayCorridas.append(novaCorrida)
                            
                        }
                        
                        let resumo = ResumoBusca(enderecoOrigem: endOrigem, enderecoDestino: endDestino, duracaoCorrida: duracao, distanciaCorrida: distancia, arrayCorridas: arrayCorridas)
                        
                        self.resumoBusca = resumo
                        print("========== RESUMO =========")
                        print(resumo)
                        DispatchQueue.main.sync {
                            self.performSegue(withIdentifier: "segueTelaBusca", sender: nil)
                        }
                        
                        
                        
                        
                    }catch{
                        
//                        let alerta = SCLAlertView()
//                        alerta.showInfo("Não enco", subTitle: <#T##String#>)
                        print("NAO DEU CERTO PEGAR O NEGOCIO")
                    }
                    
                }
            }
            
            task.resume()
            
            
        }catch{}
        
        
    }
    
    func setupTextFieldOrigem(){
        
        let btnLocalizacaoUsuario = UIButton(type: .custom)
        btnLocalizacaoUsuario.addTarget(self, action: #selector(self.localizarUsuario), for: UIControlEvents.touchUpInside)
        btnLocalizacaoUsuario.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btnLocalizacaoUsuario.setImage(#imageLiteral(resourceName: "search_minha_loc_icon"), for: .normal)
        btnLocalizacaoUsuario.contentMode = .scaleAspectFit
        btnLocalizacaoUsuario.contentHorizontalAlignment = .fill
        btnLocalizacaoUsuario.contentVerticalAlignment = .fill
        self.textFieldEnderecoOrigem.rightViewMode = .always
        self.textFieldEnderecoOrigem.rightView = btnLocalizacaoUsuario

        
        
    }
    
}


//MARK: - MKMapViewDelegate
extension TelaInicialViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if(!animated){
    
            mapaMoveuInicialmente = true
            let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder
                .reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
                                            if (error == nil) {
                                                
                                                var endereco = ""
                                                if let plmarks = placemarks {
                                                    
                                                    let firstLocation = plmarks[0]
                                                    
                                                    self.dicOrigem.updateValue(Double(firstLocation.location!.coordinate.latitude), forKey: "lat")
                                                    self.dicOrigem.updateValue(Double(firstLocation.location!.coordinate.longitude), forKey: "lng")
                                                    self.dicOrigem.updateValue("\(firstLocation.postalCode ?? "00000000")", forKey: "zipcode")
                                                    self.dicOrigem.updateValue("\(firstLocation.locality!)", forKey: "city")
                                                    self.dicOrigem.updateValue("\(firstLocation.administrativeArea!)", forKey: "state")
                                                    
                                                    //                                                print(firstLocation.locality ?? "")
                                                    //                                                print(firstLocation.administrativeArea ?? "")
                                                    //                                                print(firstLocation.postalCode ?? "")
                                                    //                                                print(firstLocation.subAdministrativeArea ?? "")
                                                    
                                                    if let thoroughfare = firstLocation.thoroughfare{
                                                        endereco += thoroughfare
                                                        
                                                        if let subThoroughfare = firstLocation.subThoroughfare{
                                                            endereco += ", " + subThoroughfare
                                                        }
                                                    }
                                                    self.dicOrigem.updateValue(endereco, forKey: "address")
                                                    
                                                    self.textFieldEnderecoOrigem.text = endereco
                                                }
                                            }
                                            else {
                                                
                                                print("ERROR AO FAZER DECODING")
                                                // Error
                                                
                                            }
                })
            
        }
        
        
        
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
        if(fullyRendered){
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.blurView.alpha = 0.0
            })
            
        }
    }
}

extension TelaInicialViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localizacao = locations.last!

        if(!mapaMoveuInicialmente){
            
            //Criando o span
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            //Criando Região
            let regiao = MKCoordinateRegion(center: localizacao.coordinate, span: span)
            //Setando o mapa a partir da região
            self.mapView.setRegion(regiao, animated: false)
            //Setando que o mapa ja se moveu
            mapaMoveuInicialmente = true
        }
        
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        
    }
}

extension TelaInicialViewController : UITextFieldDelegate{
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField == self.textFieldEnderecoOrigem){
            
            let buscarEnderecoViewController = storyboard?.instantiateViewController(withIdentifier: "tmBuscaEndereco") as! TMBuscaEnderecoViewController
            buscarEnderecoViewController.selecionouEndereco = {[weak self] (dicionarioEndereco) in
                
                if let _ = self {
                    
                    self?.dicOrigem = dicionarioEndereco
                    
                    
                    let lat = dicionarioEndereco["latitude"] as! CLLocationDegrees
                    let lng = dicionarioEndereco["longitude"] as! CLLocationDegrees
                    let location = CLLocation(latitude: lat, longitude: lng)
                    self?.mapView.setCenter(location.coordinate, animated: true)
                    
                    self?.textFieldEnderecoOrigem.text = dicionarioEndereco["address"] as? String
                }
                
            }
            //            self.present(self.googlePlacesOrigem, animated: true)
            self.present(buscarEnderecoViewController, animated: true, completion: nil)
        }else if (textField == self.textFieldEnderecoDestino){
            
            let buscarEnderecoViewController = storyboard?.instantiateViewController(withIdentifier: "tmBuscaEndereco") as! TMBuscaEnderecoViewController
            buscarEnderecoViewController.selecionouEndereco = {[weak self] (dicionarioEndereco) in
                
                if let _ = self {
                    
                    self?.dicDestino = dicionarioEndereco
                    
                    let lat = dicionarioEndereco["latitude"] as! CLLocationDegrees
                    let lng = dicionarioEndereco["longitude"] as! CLLocationDegrees
                    
                    self?.textFieldEnderecoDestino.text = dicionarioEndereco["address"] as? String
                }
                
            }
            //            self.present(self.googlePlacesOrigem, animated: true)
            self.present(buscarEnderecoViewController, animated: true, completion: nil)
            //            self.present(self.googlePlacesDestino, animated: true)
        }
        return false
        
    }
}


extension TelaInicialViewController : GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("Falhou com erro")
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        print("Cancelou")
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude), completionHandler: { (placemarks, error) in
            
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
                    
                    if(viewController == self.googlePlacesOrigem){
                        self.dicOrigem.updateValue(Double(firstLocation.location!.coordinate.latitude), forKey: "lat")
                        self.dicOrigem.updateValue(Double(firstLocation.location!.coordinate.longitude), forKey: "lng")
                        self.dicOrigem.updateValue("\(firstLocation.postalCode!)", forKey: "zipcode")
                        self.dicOrigem.updateValue("\(firstLocation.locality!)", forKey: "city")
                        self.dicOrigem.updateValue("\(firstLocation.administrativeArea!)", forKey: "state")
                        self.dicOrigem.updateValue(place.formattedAddress ?? "", forKey: "address")
                        
                        self.textFieldEnderecoOrigem.text = place.formattedAddress
                        
                        self.mapView.setCenter(place.coordinate, animated: true)
                        
                    }else if(viewController == self.googlePlacesDestino){
                        self.dicDestino.updateValue(Double(firstLocation.location!.coordinate.latitude), forKey: "lat")
                        self.dicDestino.updateValue(Double(firstLocation.location!.coordinate.longitude), forKey: "lng")
                        self.dicDestino.updateValue("\(firstLocation.postalCode!)", forKey: "zipcode")
                        self.dicDestino.updateValue("\(firstLocation.locality!)", forKey: "city")
                        self.dicDestino.updateValue("\(firstLocation.administrativeArea!)", forKey: "state")
                        self.dicDestino.updateValue(place.formattedAddress ?? "", forKey: "address")
                        
                        self.textFieldEnderecoDestino.text = place.formattedAddress
                    }
                    
                }
            }
            else {
                // An error occurred during geocoding.
                print("Não deu certo")
                
            }
            viewController.dismiss(animated: true, completion: nil)
        })
        
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
