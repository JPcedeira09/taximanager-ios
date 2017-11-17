//
//  FavoritosAdicionarViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 07/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner

class TMFavoritosAdicionarViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var txtFieldNomeEndereco: UITextField!
    @IBOutlet weak var txtFieldEndereco: UITextField!
    
    //MARK: - Propriedades
    var dicFavorito : [String: Any] = [:]
    var arrayFavoritos : [[String: Any]] = []
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.txtFieldEndereco.delegate = self
        
        let defaults = UserDefaults.standard
        if let favoritos = defaults.value(forKey: "arrayFavoritos") as? [[String : Any]]{
            
            self.arrayFavoritos = favoritos
        }
    }
    //MARK: - Metodos
    
    //MARK: - IBActions
    
    @IBAction func fechar(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func criarFavorito(_ sender: UIButton){
    
        let url = "https://api.taximanager.com.br/v1/taximanager/employees/bookmarks"
        let defaults = UserDefaults.standard
        let headers : [String:String] = ["Authorization" : defaults.value(forKey: "token") as! String]
        
        var parameters : [String:Any] = [:]
        self.dicFavorito["name"] = self.txtFieldNomeEndereco.text
        parameters["mainText"] = self.txtFieldNomeEndereco.text
        parameters["secondaryText"] = self.txtFieldNomeEndereco.text
        parameters["address"] = self.dicFavorito["address"] as! String
        parameters["number"] = self.dicFavorito["number"] as! String
        parameters["district"] = self.dicFavorito["district"] as! String
        parameters["city"] = self.dicFavorito["city"] as! String
        parameters["state"] = self.dicFavorito["state"] as! String
        parameters["zipcode"] = self.dicFavorito["zipcode"] as! String
        parameters["latitude"] = self.dicFavorito["lat"] as! Double
        parameters["longitude"] = self.dicFavorito["lng"] as! Double
        
        
        SwiftSpinner.show("Salvando...", animated: true)
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, headers: headers).responseJSON { (response) in
            
            SwiftSpinner.hide()
            self.dismiss(animated: true)
            if let err = response.error{
                
            }
            
            if(response.result.isSuccess){
                
                
                let jsonData = response.result.value as! [String : Any]
                
                let records = jsonData["records"] as! [[String : AnyObject]]
                var arrayCorridas : [Corrida] = []
                
                for record in records{
                    
                    self.dicFavorito["id"] = record["id"] as! Double
                }
                    
                
                self.arrayFavoritos.insert(self.dicFavorito, at: 0)
                
                defaults.set(self.arrayFavoritos, forKey: "arrayFavoritos")
            }
            
        }
    }
    
}

extension TMFavoritosAdicionarViewController : UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == self.txtFieldEndereco){
            
            let buscarEnderecoViewController = storyboard?.instantiateViewController(withIdentifier: "tmBuscaEndereco") as! TMBuscaEnderecoViewController
            buscarEnderecoViewController.selecionouEndereco = {[weak self] (dicionarioEndereco) in
                
                if let _ = self {
                    
//                    self?.dicFavorito = dicionarioEndereco
//                    self?.txtFieldEndereco.text = dicionarioEndereco["address"] as? String
                }
            }
            self.present(buscarEnderecoViewController, animated: true, completion: nil)
        }
    }
    
}
