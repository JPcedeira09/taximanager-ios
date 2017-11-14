//
//  TMFavoritosViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 01/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import Alamofire

class TMFavoritosViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Propriedades
    
    var arrayFavoritos = [[String:Any]]()
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "TMFavoritosCell", bundle: nil), forCellReuseIdentifier: "tmFavoritosCell")
        let defaults = UserDefaults.standard
        if let favoritos = defaults.value(forKey: "arrayFavoritos") as? [[String : Any]]{
            
            self.arrayFavoritos = favoritos
        }
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        let defaults = UserDefaults.standard
        if let favoritos = defaults.value(forKey: "arrayFavoritos") as? [[String : Any]]{
            
            self.arrayFavoritos = favoritos
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Metodos
    @IBAction func fechar(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
    
}


extension TMFavoritosViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrayFavoritos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tmFavoritosCell", for: indexPath) as! TMFavoritosCell
        
        let favorito = self.arrayFavoritos[indexPath.row]
        cell.labelTitulo.text = favorito["name"] as? String
        cell.labelEndereco1.text = favorito["address"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            
            
            let url = "https://api.taximanager.com.br/v1/taximanager/employees/bookmarks/" + "\(self.arrayFavoritos[indexPath.row]["id"] as! Double)"
            
            print("DELETEEEEEEE")
            
            self.arrayFavoritos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
            
            let defaults = UserDefaults.standard
            let headers : [String:String] = ["Authorization" : defaults.value(forKey: "token") as! String]
            
            Alamofire.request(url, method: .delete, parameters: nil, headers: headers).responseJSON(completionHandler: { (response) in
                
                
                print("VOLTOU DO RESPONSE JSON")
                if let err = response.error{
                    print(err.localizedDescription)
                }
                
                
                
                if(response.result.isSuccess){
                    
                    print("SUCESSO")
                    UserDefaults.standard.setValue(self.arrayFavoritos, forKey: "arrayFavoritos")
                    
                }
                
            })
            
        }
    }
}
