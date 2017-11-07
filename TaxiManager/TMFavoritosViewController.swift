//
//  TMFavoritosViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 01/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit

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
        return 105
    }
}
