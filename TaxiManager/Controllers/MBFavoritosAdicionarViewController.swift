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

class MBFavoritosAdicionarViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var txtFieldNomeEndereco: UITextField!
    @IBOutlet weak var txtFieldEndereco: UITextField!
    
    //MARK: - Propriedades
    var dicFavorito : [String: Any] = [:]
    var arrayFavoritos : [[String: Any]] = []
    
    var bookmarkAddress : MBAddress!
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
        
        
 
        if(self.bookmarkAddress != nil && self.txtFieldNomeEndereco.text! != ""){
            let bookmark = MBBookmark(withLocation: self.bookmarkAddress, mainText: self.txtFieldNomeEndereco.text!, secondaryText: self.txtFieldNomeEndereco.text!)
            
            SwiftSpinner.show("Salvando...", animated: true)
            MobiliteeProvider.api.request(.postBookmark(bookmark: bookmark), completion: { (result) in
            
            MBUser.update()
            SwiftSpinner.hide()
                switch (result){
                
                case let .success(response):
                    
                
                        do{
                            
                            //                        print(try response.mapString())
                            let mbBookmarks = try response.map([MBBookmark].self, atKeyPath: "records")
                            
                            if(MBUser.currentUser?.bookmarks == nil){
                                
                                MBUser.currentUser!.bookmarks = [MBBookmark]()
                            }
                            
                            MBUser.currentUser!.bookmarks! += mbBookmarks
                            
                            
                            
                            //                        print(MBUser.currentUser?.bookmarks)
                        }catch{
                            
                            print("caiu no catch")
                        }
                        
                        print("Chegou aqui")
                        self.dismiss(animated: true, completion: nil)
                    
                    
                case let .failure(error):
                    
                    print(error.localizedDescription)
                    self.dismiss(animated: true)
                
                }
                
                
            })
            
            
        }
    }
    
}

extension MBFavoritosAdicionarViewController : UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == self.txtFieldEndereco){
            
            let buscarEnderecoViewController = storyboard?.instantiateViewController(withIdentifier: "tmBuscaEndereco") as! MBBuscaEnderecoViewController
            buscarEnderecoViewController.selecionouEndereco = {[weak self] (dicionarioEndereco) in
                
                if let _ = self {
                    
                    self?.bookmarkAddress = MBAddress(fromLocation: dicionarioEndereco)
//                    self?.dicFavorito = dicionarioEndereco
                    self?.txtFieldEndereco.text = dicionarioEndereco.address as? String
                }
            }
            self.present(buscarEnderecoViewController, animated: true, completion: nil)
        }
    }
    
}