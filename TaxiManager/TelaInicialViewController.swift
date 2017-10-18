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
//Open Weather API
//fddaea8c38c5d8cee66a234b2f812baa
//api.openweathermap.org/data/2.5/weather?lat=35&lon=139

class TelaInicialViewController: UIViewController {
    
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageViewPin: UIImageView!
    
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
    
    func checarDistancia(origem : [String : Any], destino : [String : Any]){
        
        SwiftSpinner.show("Verificando as melhores opções...")
        let urlRequest = "https://maps.googleapis.com/maps/api/distancematrix/json"
        let origins = "\(origem["lat"]!)" + "," + "\(origem["lng"]!)"
        let destinations = "\(destino["lat"]!)" + "," + "\(destino["lng"]!)"
        
        let parametros = ["key": "AIzaSyAL4jaoV5Sl42t2XXgOjDRV-vIMGCWBCPI" , "origins" : origins, "destinations": destinations]
        
        
//        print(parametros)
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
                    let status = elemento["status"] as! String
                    
                    let duracaoFormatada  = Int(duracao["text"]!.components(separatedBy: " ")[0])!
                    let distanciaFormatada = distancia["value"] as! Int
                    
                    self.checarPrecos(origem: self.dicOrigem, destino: self.dicDestino, device: [:], distancia: distanciaFormatada, duracao: duracaoFormatada)
//                    print("Status", status)
//                    print("Duracao", duracao)
//                    print("Distancia", distancia)
//
                }
            }
        }
    }
    
    func checarPrecos(origem : [String : Any], destino : [String : Any], device: [String : String], distancia : Int, duracao : Int){
        
        let parametros = ["device" : device, "start" : origem, "end" : destino, "distance" : 3200 , "duration" : 11] as [String : Any]
        
        let url = URL(string: "http://estimate.taximanager.com.br/v1/estimates")!
        let autorizationKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNTAwMzM4MjU0fQ.B2Nch63Zu0IzJDepVTDXqq8ydbIVDiUmU6vV_7eQocw"
        do
        {
            let body = try JSONSerialization.data(withJSONObject: parametros)
            
            //            print(NSString(data: body, encoding: String.Encoding.utf8.rawValue))
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(autorizationKey, forHTTPHeaderField: "Authorization")
            request.httpBody = body
            let session = URLSession.shared
            let task = session.dataTask(with: request){
                (data, response, error) in
                
//                print(error)
                
                if(error == nil){
                    
                    let jsonData = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                    
//                    print(jsonData)
//                    print(String(data: data!, encoding: .utf8))
//                    print(response)
//
                    SwiftSpinner.hide()
//                    DispatchQueue.main.sync {
//                        self.performSegue(withIdentifier: "segueTelaBusca", sender: nil)
//                    }
                    
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
                    guard let distanciaJson = jsonData["distance"] as! Int? else {
                        
                        print("falhou distancia")
                        return
                    }
                    guard let duracaoJson = jsonData["duration"] as! Int? else {
                        
                        print("falhou duracao")
                        return
                    }
                    let records = jsonData["records"] as! [[String : AnyObject]]
                    var arrayCorridas : [Corrida] = []
                    for record in records{
                        

                        print()
//                        print(record["alert_message"])
                        guard let alertMessage = record["alert_message"] as! String? else{
                            print("Falhou 01")
                            return
                        }
//                        print(record["id"])
                        guard let id = record["id"] as! Int? else{
                            print("Falhou 02")
                            return
                        }
                        guard let modality = record["modality"] as! [String : AnyObject]? else{
                            
                            print("Falhou 00")
                            return
                        }
//                        print(record["name"])
                        guard let name = modality["name"] as! String? else{
                            print("Falhou 03")
                            return
                        }
//                        print(record["price"])
                        guard let price = record["price"] as! String? else{
                            print("Falhou 04")
                            return
                        }
                        var url = ""
                        if(record["url"] as! String? != nil){
                            url = record["url"] as! String
                        }
//                        print(record["url"])
//                        guard let url = record["url"] as! String? else{
//                            print("Falhou 05")
//                            return
//                        }
//                        print(record["waiting_time"])
                        guard let waitingTime = record["waiting_time"] as! Int? else{
                            print("Falhou 06")
                            return
                        }
                        
//                        guard let urlLogo = record["url_logo"] as! String? else{
//                            print("Falhou 07")
//                            return
//                        }
                        
                        var urlLogo = ""
                        if(record["url_logo"] as! String? != nil){
                            urlLogo = record["url_logo"] as! String
                        }
                    
                        let corrida = Corrida(alertMessage: alertMessage, id: id, name: name, price: price, url: url, urlLogo: urlLogo, waitingTime: waitingTime / 60)
                        
                       arrayCorridas.append(corrida)
                        print(corrida)
                    }
                    
                    let resumo = ResumoBusca(enderecoOrigem: endOrigem, enderecoDestino: endDestino, duracaoCorrida: duracao, distanciaCorrida: distancia, arrayCorridas: arrayCorridas)
                    
                    self.resumoBusca = resumo
                    DispatchQueue.main.sync {
                        self.performSegue(withIdentifier: "segueTelaBusca", sender: nil)
                    }
                }
            }
            
            task.resume()
            
            
        }catch{}
        
        
    }
    
    func setupTextFieldOrigem(){
        
        let btnLocalizacaoUsuario = UIButton(type: .custom)
        btnLocalizacaoUsuario.addTarget(self, action: #selector(self.localizarUsuario), for: UIControlEvents.touchUpInside)
        btnLocalizacaoUsuario.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnLocalizacaoUsuario.setImage(#imageLiteral(resourceName: "search_minha_loc_icon"), for: .normal)
        self.textFieldEnderecoOrigem.rightViewMode = .always
        self.textFieldEnderecoOrigem.rightView = btnLocalizacaoUsuario
        
    }
    
}


//MARK: - MKMapViewDelegate
extension TelaInicialViewController : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
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
                                                self.dicOrigem.updateValue("\(firstLocation.postalCode!)", forKey: "zipcode")
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
                                            // Error
                                            
                                        }
            })
        
        
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
        
        
        
        if(!mapaMoveuInicialmente){
            let localizacao = locations.last!
            //Criando o span
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            //Criando Região
            let regiao = MKCoordinateRegion(center: localizacao.coordinate, span: span)
            //Setando o mapa a partir da região
            self.mapView.setRegion(regiao, animated: true)
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
            
            self.present(self.googlePlacesOrigem, animated: true)
        }else if (textField == self.textFieldEnderecoDestino){
            
            self.present(self.googlePlacesDestino, animated: true)
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
        
        
        print(place.formattedAddress)
        for component in place.addressComponents!{
            
            print(component.type + ": " + component.name)
        }
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
