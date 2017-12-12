//
//  MBInitialViewViewController.swift
//  TaxiManager
//
//  Created by Joao Paulo on 07/12/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
import CoreLocation
import Alamofire
import SwiftSpinner
import Contacts
import SCLAlertView
import FirebaseAnalytics
import Crashlytics
//Open Weather API
//fddaea8c38c5d8cee66a234b2f812baa
//api.openweathermap.org/data/2.5/weather?lat=35&lon=139

class MBInitialViewViewController: UIViewController {
    
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
    
    //MARK: - Properties.
    var locationManager = CLLocationManager()
    var mapaMoveuInicialmente = false
    let googlePlacesOrigem = GMSAutocompleteViewController()
    let googlePlacesDestino = GMSAutocompleteViewController()
    var dicOrigem : [String: Any] = [:]
    var dicDestino : [String: Any] = [:]
    
    var startAddress : MBLocation?
    var endAddress : MBLocation?
    var searchResult : MBSearchResult?
    
    //MARK: - View Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        // func valid id status
      self.getStatusEmployee()
   
        //Maps config.
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        //CoreLocation.
        self.pedirAutorizacaoLocalizacaoUsuario()
        
        //Textfield.
        self.textFieldEnderecoOrigem.delegate = self
        self.textFieldEnderecoDestino.delegate = self
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logotipo_fundo_preto.png"))
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        navigationItem.titleView = titleView
        
        self.setupTextFieldOrigem()
        self.atualizarLabelData()
        
        // User Defaults.
        let currentUser = UserDefaults.standard.value(forKey: "user")
        if let currentUser = currentUser as? Data{
            let usuarioInside = try? JSONDecoder().decode(MBUser.self, from: currentUser) as? MBUser
            print("Usuario inside: \(usuarioInside)")
        }
    }
    
    @objc func localizarUsuario(){
        
        let location = self.locationManager.location!
        let geocoder = CLGeocoder()
        // Look up the location and pass it to the completion handler.
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
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
                    self.textFieldEnderecoOrigem.text = endereco
                    self.mapView.setCenter(firstLocation.location!.coordinate, animated: true)
                }
            }
            else {
                print("INFO: location error.")
            }
        })
    }
    
    @IBAction func btnProximoPasso(_ sender: UIButton) {
        
        if(self.textFieldEnderecoOrigem.text != "" && self.textFieldEnderecoDestino.text != ""){
            self.checkDistance(start: self.startAddress!, end: self.endAddress!)
        }else{
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5) {
                self.textFieldDestinoTopSpaceConstraint.constant = 8
                self.view.layoutIfNeeded()
            }
            sender.setTitle("Ver melhores opções", for: .normal)
        }
    }
    
    //MARK: - Navegation.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "segueTelaBusca"){
            let buscaViewController = segue.destination as! MBTelaBuscaViewController
            //buscaViewController.resumoBusca = self.resumoBusca
            buscaViewController.searchResult = self.searchResult
        }
    }
    
    //MARK: - methods.
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
        dateFormatter.dateStyle = .full
        
        self.labelData.text = dateFormatter.string(from: dataAtual)
    }
    
    func checkDistance(start : MBLocation, end : MBLocation){
        
        SwiftSpinner.show("Verificando as melhores opções...")
        let urlRequest = "https://maps.googleapis.com/maps/api/distancematrix/json"
        let origins = "\(start.latitude)" + "," + "\(start.longitude)"
        let destinations = "\(end.latitude)" + "," + "\(end.longitude)"
        
        let parametros = ["key": "AIzaSyDOebYw-atZqhQxDKX-D5Ps5Dje0f29RSo" , "origins" : origins, "destinations": destinations]
        Alamofire.request(urlRequest, method: HTTPMethod.get, parameters: parametros).responseJSON { (response) in
            
            if(response.result.isSuccess){
                
                if let json = response.result.value as? [String : AnyObject]{
                    
                    print(json)
                    let rows = json["rows"] as! [AnyObject]
                    let pre_elements = rows[0] as! [String : AnyObject]
                    let elements = pre_elements["elements"] as! [AnyObject]
                    let elemento = elements[0] as! [String : AnyObject]
                    
                    //Final Properties.
                    let duracao = elemento["duration"] as! [String : AnyObject]
                    let distancia = elemento["distance"] as! [String : AnyObject]
                    
                    let duracaoFormatada  = Int(duracao["text"]!.components(separatedBy: " ")[0])!
                    let distanciaFormatada = distancia["value"] as! Int
                    
                    self.estimatePrices(startAddress: self.startAddress!, endAddress: self.endAddress!, distance: distanciaFormatada, duration: duracaoFormatada)
                }
            }
        }
    }
    
    func estimatePrices(startAddress : MBLocation, endAddress : MBLocation, distance : Int, duration : Int){
      //  print("MOYA URL \(startAddress)/\(endAddress)/\(distance)/\(duration)/\(MBUser.currentUser!.id)/\(MBUser.currentUser!.companyId))")
      MobiliteeProvider.api.request(.estimate(start: startAddress, end: endAddress, distance: distance, duration: duration, userId: MBUser.currentUser!.id, companyId: MBUser.currentUser!.companyId)) { (result) in
            
            SwiftSpinner.hide()
            
            do{
                switch(result){
                case let .success(response):
                    print(response)
                    //                    print("----------- INFO: RESPONSE estimatePrices ----------")
                    //                     print(response)
                    //                    print("----------- INFO: RESPONSE estimatePrices ----------")
                    
                    let travels = try response.map([MBRide].self, atKeyPath: "records")
                    
                    //                    print("----------- INFO: MAPED estimatePrices ----------")
                    //                    print("INFO: TRAVELS:\(travels)")
                    //                    print("----------- INFO: MAPED estimatePrices ----------")
                    
                    self.searchResult = MBSearchResult(startAddress: startAddress, endAddress: endAddress, duration: duration, distance: distance, travels: travels)
Analytics.logEvent("resultClick", parameters: ["id" : travels.first?.id,"alertMessage" : travels.first?.alertMessage,"waitingTime" : travels.first?.waitingTime,"name" : travels.first?.name,"price" : travels.first?.price,"urlDeeplink" : travels.first?.urlDeeplink,"urlLogo" : travels.first?.urlLogo,"urlStore" : travels.first?.urlStore,"urlWeb" : travels.first?.urlWeb,"uuid" : travels.first?.uuid,"ModalityID" : travels.first?.modality.id,"ModalityName" : travels.first?.modality.name])
                   
                    self.performSegue(withIdentifier: "segueTelaBusca", sender: nil)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }catch{
                print(error.localizedDescription)
            }
        }
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
    
    func getStatusEmployee() {
        let urlRequest = URL(string:  "https://api.taximanager.com.br/v1/taximanager/users/\((MBUser.currentUser?.id)!)")

        // print("\n /n INFO: URL:\(urlRequest)\n /n ")
        let header = ["Content-Type" : "application/json",
                      "Authorization" : MBUser.currentUser?.token ?? ""]
        Alamofire.request(urlRequest!, method: HTTPMethod.get,headers : header).responseJSON { (response) in
            if(response.result.isSuccess){
                print(response)
                if let json = response.result.value as? [String : AnyObject]{
                    var mbUser: MBUserInside = MBUserInside(from: json)
                    print("\n ----------------INFO:REQUEST getStatusEmployee---------------- \n")
                    print(mbUser)
                    print(mbUser.statusID)
                    print("\n ----------------INFO:REQUEST getStatusEmployee---------------- \n")
                    if(mbUser.statusID == 1){
                        print("INFO O STATUD DO USER É : \(mbUser.isBlocked)")
                    }else if (mbUser.statusID == 2 || mbUser.id == 3){
                        print("INFO O STATUD DO USER É : \(mbUser.isBlocked)")
                        MBUser.logout()
                        let alertDemitido = SCLAlertView()
                        alertDemitido.showNotice("Ops...", subTitle: "Ops, seu usuario foi desautorizado, entre em contato com a área de transporte da sua empresa.")
                        self.performSegue(withIdentifier: "MBLoginViewController", sender: nil)
                    }
                }
            }else{
                print("INFO: ERROR ON REQUEST getStatusEmployee - \(response.error?.localizedDescription)")
             }
        }
    }
}

//MARK: - MKMapViewDelegate.
extension MBInitialViewViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if(!animated){
            mapaMoveuInicialmente = true
            let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            let geocoder = CLGeocoder()
            // Look up the location and pass it to the completion handler.
            geocoder.reverseGeocodeLocation(location,
                                            completionHandler: { (placemarks, error) in
                                                if (error == nil) {
                                                    
                                                    var endereco = ""
                                                    if let plmarks = placemarks {
                                                        
                                                        let firstLocation = plmarks[0]
                                                        self.dicOrigem.updateValue(Double(firstLocation.location!.coordinate.latitude), forKey: "lat")
                                                        self.dicOrigem.updateValue(Double(firstLocation.location!.coordinate.longitude), forKey: "lng")
                                                        self.dicOrigem.updateValue("\(firstLocation.postalCode ?? "00000000")", forKey: "zipcode")
                                                        self.dicOrigem.updateValue("\(firstLocation.locality ?? "")", forKey: "city")
                                                        self.dicOrigem.updateValue("\(firstLocation.administrativeArea ?? "")", forKey: "state")
                                                        
                                                        if let thoroughfare = firstLocation.thoroughfare{
                                                            endereco += thoroughfare
                                                            
                                                            if let subThoroughfare = firstLocation.subThoroughfare{
                                                                endereco += ", " + subThoroughfare
                                                            }
                                                        }
                                                        
                                                        let address = MBAddress(latitude: firstLocation.location?.coordinate.latitude ?? 0.0,
                                                                                longitude: firstLocation.location?.coordinate.longitude ?? 0.0,
                                                                                address: endereco,
                                                                                district: "",
                                                                                city: firstLocation.locality ?? "",
                                                                                state: firstLocation.administrativeArea ?? "",
                                                                                zipcode: firstLocation.postalCode ?? "00000000",
                                                                                number: "")
                                                        self.startAddress = address
                                                        self.dicOrigem.updateValue(endereco, forKey: "address")
                                                        self.textFieldEnderecoOrigem.text = endereco
                                                    }
                                                }
                                                else {
                                                    print("INFO: Decoding error.")
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

extension MBInitialViewViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localizacao = locations.last!
        if(!mapaMoveuInicialmente){
            
            //span created.
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            //region created.
            let regiao = MKCoordinateRegion(center: localizacao.coordinate, span: span)
            //set the map on region.
            self.mapView.setRegion(regiao, animated: false)
            //set the moved map.
            mapaMoveuInicialmente = true
        }
    }
    
}

extension MBInitialViewViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if(textField == self.textFieldEnderecoOrigem){
            
            let buscarEnderecoViewController = storyboard?.instantiateViewController(withIdentifier: "tmBuscaEndereco") as! MBBuscaEnderecoViewController
            buscarEnderecoViewController.selecionouEndereco = {[weak self] (dicionarioEndereco) in
                
                if let _ = self {
                    
                    self?.startAddress = dicionarioEndereco
                    let lat = dicionarioEndereco.latitude
                    let lng = dicionarioEndereco.longitude
                    let location = CLLocation(latitude: lat, longitude: lng)
                    self?.mapView.setCenter(location.coordinate, animated: true)
                    self?.textFieldEnderecoOrigem.text = dicionarioEndereco.address
                }
            }
            
            self.present(buscarEnderecoViewController, animated: true, completion: nil)
            
        }else if (textField == self.textFieldEnderecoDestino){
            let buscarEnderecoViewController = storyboard?.instantiateViewController(withIdentifier: "tmBuscaEndereco") as! MBBuscaEnderecoViewController
            buscarEnderecoViewController.selecionouEndereco = {[weak self] (dicionarioEndereco) in
                if let _ = self {
                    self?.endAddress = dicionarioEndereco
                    self?.textFieldEnderecoDestino.text = dicionarioEndereco.address
                }
            }
            self.present(buscarEnderecoViewController, animated: true, completion: nil)
        }
        return false
    }
}

//passar user_id e company_id

//        let employeeId = MBUser.currentUser!.employeeId
//        let companyId = MBUser.currentUser!.companyId
//
//
//        do
//        {
//
//            let parametros = ["device" : device, "start" : try startAddress.asDictionary(), "end" : try endAddress.asDictionary(), "distance" : distance , "duration" : duration, "company_id" : companyId, "user_id" : employeeId] as [String : Any]
//
//            let url = URL(string: "http://estimate.taximanager.com.br/v1/estimates")!
//            let autorizationKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNTAwMzM4MjU0fQ.B2Nch63Zu0IzJDepVTDXqq8ydbIVDiUmU6vV_7eQocw"
//
//            let body = try JSONSerialization.data(withJSONObject: parametros)
//
////            print("XXXXXXXXXXXXXXXXXXX")
////
////            print(parametros)
////
////            print("XXXXXXXXXXXXXXXXXXX")
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue(autorizationKey, forHTTPHeaderField: "Authorization")
//            request.httpBody = body
//            let session = URLSession.shared
//            let task = session.dataTask(with: request){
//                (data, response, error) in
//
//                SwiftSpinner.hide()
//                if(error == nil){
//
//                    print(String(data: data! ,encoding: .utf8))
//
//                    do{
//                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
//
//                        let origem = jsonData["start"] as! [String : AnyObject]
//                        let destino = jsonData["end"] as! [String : AnyObject]
//
//                        guard let endOrigem = origem["address"] as! String? else {
//                            print("falhou end origem")
//                            return
//                        }
//
//                        guard let endDestino = destino["address"] as! String? else {
//                            print("falhou end destino")
//                            return
//                        }
//
//                        guard let records = jsonData["records"] as? [[String : AnyObject]] else {
//
//                            let alerta = SCLAlertView()
//                            alerta.showInfo("Ops!", subTitle: "Não conseguimos encontrar motoristas para estes endereços.")
//                            return
//                        }
//
//                        var arrayCorridas : [Corrida] = []
//
//                        for record in records{
//
//                            var novaCorrida = Corrida()
//
//                            if let alertMessage = record["alert_message"] as? String{
//                                novaCorrida.alertMessage = alertMessage
//                            }
//
//                            if let id = record["id"] as? Int {
//                                novaCorrida.id = id
//                            }
//                            if let name = record["name"] as? String{
//
//                                novaCorrida.name = name
//                            }
//
//                            if let modality = record["modality"] as? [String : AnyObject]{
//
//                                if let name = modality["name"] as? String{
//
//                                    novaCorrida.modalityName = name
//                                }
//                            }
//
//                            if let price = record["price"] as? String {
//
//                                novaCorrida.price = price
//                            }
//
//                            if let waitingTime = record["waiting_time"] as? Int{
//
//                                novaCorrida.waitingTime = waitingTime
//                            }
//
//                            if let urlDeepLinkString = record["url"] as? String{
//
//                                novaCorrida.urlDeeplink = URL(string: urlDeepLinkString)
//                            }
//
//                            if let urlLogoString = record["url_logo"] as? String{
//
//                                novaCorrida.urlLogo = URL(string: urlLogoString)
//                            }
//
//                            if let urlLojaString = record["url_loja_ios"] as? String{
//
//                                novaCorrida.urlLoja = URL(string: urlLojaString)
//                            }
//
//                            if let urlWebString = record["url_web"] as? String{
//
//                                novaCorrida.urlWeb = URL(string: urlWebString)
//                            }
//
//
//                            arrayCorridas.append(novaCorrida)
//
//                        }
//
//                        let resumo = ResumoBusca(enderecoOrigem: endOrigem, enderecoDestino: endDestino, duracaoCorrida: duration, distanciaCorrida: distance, arrayCorridas: arrayCorridas)
//
//                        self.resumoBusca = resumo
//                        print("========== RESUMO =========")
//                        print(resumo)
//                        DispatchQueue.main.sync {
//                            self.performSegue(withIdentifier: "segueTelaBusca", sender: nil)
//                        }
//
//
//
//
//                    }catch{
//
//                        //                        let alerta = SCLAlertView()
//                        //                        alerta.showInfo("Não enco", subTitle: <#T##String#>)
//                        print("NAO DEU CERTO PEGAR O NEGOCIO")
//                    }
//
//                }
//            }
//
//            task.resume()
//
//
//        }catch{}
//}



//    func checarPrecos(origem : [String : Any], destino : [String : Any], device: [String : String], distancia : Int, duracao : Int){
//
//        //passar user_id e company_id
//
//        let idUsuario = UserDefaults.standard.value(forKey: "idUsuario") as! Int
//        let idEmpresa = UserDefaults.standard.value(forKey: "idEmpresa") as! Int
//
//
//        let parametros = ["device" : device, "start" : origem, "end" : destino, "distance" : distancia , "duration" : duracao, "company_id" : idEmpresa, "user_id" : idUsuario] as [String : Any]
//
//        let url = URL(string: "http://estimate.taximanager.com.br/v1/estimates")!
//        let autorizationKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNTAwMzM4MjU0fQ.B2Nch63Zu0IzJDepVTDXqq8ydbIVDiUmU6vV_7eQocw"
//        do
//        {
//
//
//            let body = try JSONSerialization.data(withJSONObject: parametros)
//
//            print("XXXXXXXXXXXXXXXXXXX")
//
//            print(parametros)
//
//            print("XXXXXXXXXXXXXXXXXXX")
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue(autorizationKey, forHTTPHeaderField: "Authorization")
//            request.httpBody = body
//            let session = URLSession.shared
//            let task = session.dataTask(with: request){
//                (data, response, error) in
//
//                SwiftSpinner.hide()
//                if(error == nil){
//
//
//                    do{
//                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
//
//                        let origem = jsonData["start"] as! [String : AnyObject]
//                        let destino = jsonData["end"] as! [String : AnyObject]
//
//                        guard let endOrigem = origem["address"] as! String? else {
//                            print("falhou end origem")
//                            return
//                        }
//
//                        guard let endDestino = destino["address"] as! String? else {
//                            print("falhou end destino")
//                            return
//                        }
//
//                        guard let records = jsonData["records"] as? [[String : AnyObject]] else {
//
//                            let alerta = SCLAlertView()
//                            alerta.showInfo("Ops!", subTitle: "Não conseguimos encontrar motoristas para estes endereços.")
//                            return
//                        }
//
//                        var arrayCorridas : [Corrida] = []
//
//                        for record in records{
//
//                            var novaCorrida = Corrida()
//
//                            if let alertMessage = record["alert_message"] as? String{
//                                novaCorrida.alertMessage = alertMessage
//                            }
//
//                            if let id = record["id"] as? Int {
//                                novaCorrida.id = id
//                            }
//                            if let name = record["name"] as? String{
//
//                                novaCorrida.name = name
//                            }
//
//                            if let modality = record["modality"] as? [String : AnyObject]{
//
//                                if let name = modality["name"] as? String{
//
//                                    novaCorrida.modalityName = name
//                                }
//                            }
//
//                            if let price = record["price"] as? String {
//
//                                novaCorrida.price = price
//                            }
//
//                            if let waitingTime = record["waiting_time"] as? Int{
//
//                                novaCorrida.waitingTime = waitingTime
//                            }
//
//                            if let urlDeepLinkString = record["url"] as? String{
//
//                                novaCorrida.urlDeeplink = URL(string: urlDeepLinkString)
//                            }
//
//                            if let urlLogoString = record["url_logo"] as? String{
//
//                                novaCorrida.urlLogo = URL(string: urlLogoString)
//                            }
//
//                            if let urlLojaString = record["url_loja_ios"] as? String{
//
//                                novaCorrida.urlLoja = URL(string: urlLojaString)
//                            }
//
//                            if let urlWebString = record["url_web"] as? String{
//
//                                novaCorrida.urlWeb = URL(string: urlWebString)
//                            }
//
//
//                            arrayCorridas.append(novaCorrida)
//
//                        }
//
//                        let resumo = ResumoBusca(enderecoOrigem: endOrigem, enderecoDestino: endDestino, duracaoCorrida: duracao, distanciaCorrida: distancia, arrayCorridas: arrayCorridas)
//
//                        self.resumoBusca = resumo
//                        print("========== RESUMO =========")
//                        print(resumo)
//                        DispatchQueue.main.sync {
//                            self.performSegue(withIdentifier: "segueTelaBusca", sender: nil)
//                        }
//
//
//
//
//                    }catch{
//
////                        let alerta = SCLAlertView()
////                        alerta.showInfo("Não enco", subTitle: <#T##String#>)
//                        print("NAO DEU CERTO PEGAR O NEGOCIO")
//                    }
//
//                }
//            }
//
//            task.resume()
//
//
//        }catch{}
//
//
//    }



