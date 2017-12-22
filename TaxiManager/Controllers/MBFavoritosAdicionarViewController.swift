//
//  FavoritosAdicionarViewController.swift
//  TaxiManager
//
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import Alamofire
import SwiftSpinner
import SCLAlertView

class MBFavoritosAdicionarViewController: UIViewController {
    
    // set the key value to indentify the flow on the buscar endereço that came from inicitial view controller.
    let statusDestinationInicial = 0
    
    //MARK: - Outlets.
    @IBOutlet weak var txtFieldNomeEndereco: UITextField!
    @IBOutlet weak var txtFieldEndereco: UITextField!
    
    //MARK: - Properties.
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
    
    //MARK: - IBActions
    @IBAction func fechar(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func criarFavorito(_ sender: UIButton){
        if(self.bookmarkAddress != nil && self.txtFieldNomeEndereco.text! != ""){
            let bookmark = MBBookmark(withLocation: self.bookmarkAddress, mainText: self.txtFieldNomeEndereco.text!, secondaryText: self.txtFieldNomeEndereco.text!, createdAt : "", createdUser : (MBUser.currentUser?.username)!, updatedAt : "", updatedUser: "")
            
            SwiftSpinner.show("Salvando...", animated: true)
            self.postBookmark(bookmark: bookmark)
            self.dismiss(animated: true, completion: nil)
            SwiftSpinner.hide()
        }
    }
    
    //MARK: - Metodos
    func postBookmark(bookmark: MBBookmark) {
        
        let header = ["Content-Type" : "application/json",
                      "Authorization" : MBUser.currentUser?.token ?? ""]
        let postURL = URL(string: "https://api.taximanager.com.br/v1/taximanager/employees/bookmarks")
        let parametros : [String: Any]  = bookmark.toDict(bookmark) as [String:Any]
        
        Alamofire.request(postURL!, method: .post, parameters:parametros , encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { (response) -> Void in
            switch response.result {
            case .success(let data):
                print("_____________ Salvando iNFO POST BOOKMARK RESPONSE")
                guard let json = data as? [String : NSObject] else {
                    return
                }
                print(json)
                if(MBUser.currentUser?.bookmarks == nil){
                    MBUser.currentUser!.bookmarks = [MBBookmark]()
                }
                var mbBookmarks  : [MBBookmark] = []
                if(json["records"] != nil){
                    let records = json["records"] as! NSArray
                    for item in records {
                        let bookmark = MBBookmark(serializable: item as! [String : Any])
                        mbBookmarks.append(bookmark)
                    }
                    MBUser.currentUser!.bookmarks! += mbBookmarks
                    //print(data)
                    print("_____________ Salvando iNFO POST BOOKMARK RESPONSE")
                    SCLAlertView().showSuccess("Favorito adicionado!", subTitle: "Agora voce tem um novo favorito.")
                }

            case .failure(let error):
                print(error.localizedDescription)
                print("iNFO: error in localizedDescription getBookmarks")
                SCLAlertView().showError("Falha ao adicionar favorito", subTitle: "Tente mais tarde.")
            }
        }
    }
}

extension MBFavoritosAdicionarViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == self.txtFieldEndereco){
            
            let buscarEnderecoViewController = storyboard?.instantiateViewController(withIdentifier: "tmBuscaEndereco") as! MBBuscaEnderecoViewController
            
            // Set the placeholder of the buscar Endereco View controller.
            buscarEnderecoViewController.textoDestination = "Inserir local para adicionar em favoritos"
            
            // Set the flow from the initial view controller.
            buscarEnderecoViewController.destinationViewController = statusDestinationInicial
            
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

/*
 MobiliteeProvider.api.request(.postBookmark(bookmark: bookmark), completion: { (result) in
 
 print("_____________iNFO POST BOOKMARK \(bookmark)")
 
 MBUser.update()
 SwiftSpinner.hide()
 switch (result){
 case let .success(response):
 do{
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
 */
