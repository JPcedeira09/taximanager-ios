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
    
    var arrayFavoritos = [MBBookmark]()
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: "TMFavoritosCell", bundle: nil), forCellReuseIdentifier: "tmFavoritosCell")
        let defaults = UserDefaults.standard
        

//        if let favoritos = MBUser.currentUser?.bookmarks{
//
//            self.arrayFavoritos = favoritos
//        }
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
//        let defaults = UserDefaults.standard
        if let favoritos = MBUser.currentUser?.bookmarks{
            
            self.arrayFavoritos = favoritos
        }
        
        print(self.arrayFavoritos)
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
        cell.labelTitulo.text = favorito.mainText
        cell.labelEndereco1.text = favorito.address
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

            if let bookmarkId = self.arrayFavoritos[indexPath.row].id{
                self.arrayFavoritos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
                
                MobiliteeProvider.api.request(.deleteBookmark(bookmarkId: bookmarkId), completion: { (result) in
                    
                    switch(result){
                        
                        
                    case let .success(response):
                        print(response.statusCode)
                        MBUser.currentUser?.bookmarks?.remove(at: indexPath.row)
                        print(MBUser.currentUser?.bookmarks)
                    case let .failure(error):
                        
                        print(error.localizedDescription)
                    }
                })
            }

            


        }
    }
}
