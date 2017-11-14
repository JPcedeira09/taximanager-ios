//
//  TMHistoricoViewController.swift
//  TaxiManager
//
//  Created by Esdras Martins on 30/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import ExpandableCell

class TMHistoricoViewController: UIViewController{

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: ExpandableTableView!
    //MARK: - Propriedades
    
    var arrayHistorico = [[String:Any]]()
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.expandableDelegate = self
        
        self.tableView.register(UINib(nibName: "TMHistoricoViewCell", bundle: nil), forCellReuseIdentifier: "tmHistoricoCell")
        self.tableView.register(UINib(nibName: "TMHistoricoVerMaisCell", bundle: nil), forCellReuseIdentifier: "tmHistoricoDetalheCell")
        
        let defaults = UserDefaults.standard
        if let historico = defaults.value(forKey: "arrayHistorico") as? [[String : Any]]{
            
            self.arrayHistorico = historico
        }
    }
    //MARK: - Metodos
    
    //MARK: - Actions
    

    @IBAction func fechar(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension TMHistoricoViewController : ExpandableDelegate{
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        
        return [350.0]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        
        let cell = expandableTableView.dequeueReusableCell(withIdentifier: "tmHistoricoDetalheCell") as! TMHistoricoVerMaisCell
        
        let registro = self.arrayHistorico[indexPath.row]
        
        
//        registro["id"] = record["id"] as! Int
//        registro["distancia"] = record["distance"] as! NSNumber
//        registro["valor"] = record["cost"] as! NSNumber
//        registro["categoriaPlayer"] = record["description"] as! String
//        registro["nomePlayer"] = record["name"] as! String
//        registro["centroDeCusto"] = centroDeCustoObj["name"] as! String
//        registro["projeto"] = record["project"] as? String
//        registro["justificativa"] = ""
//        registro["dataInicio"] = record["startDate"] as! String
//        registro["dataFim"] = record["endDate"] as! String
//        registro["enderecoOrigem"] = record["startAddress"] as! String
//        registro["enderecoDestino"] = record["endAddress"] as! String
//
        cell.lblDistancia.text = "\((registro["distancia"] as! NSNumber)) km"
        cell.lblDuracao.text = ""
        cell.lblValor.text = "R$\(registro["valor"] as! NSNumber)"
        cell.lblFornecedor.text = registro["nomePlayer"] as? String
        cell.lblCategoria.text = registro["categoriaPlayer"] as? String
        cell.lblCentroCusto.text = registro["centroDeCusto"] as? String
        cell.lblProjeto.text = registro["projeto"] as? String
        cell.lblJustificativa.text = registro["justificativa"] as? String
        
        return [cell]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = expandableTableView.dequeueReusableCell(withIdentifier: "tmHistoricoCell") as! TMHistoricoViewCell
        
        let registro = self.arrayHistorico[indexPath.row]
        
        cell.labelOrigem.text = registro["enderecoOrigem"] as? String
        cell.labelDestino.text = registro["enderecoDestino"] as? String
        cell.labelCorrida.text = (registro["categoriaPlayer"] as! String) + " - R$" + "\(registro["valor"] as! NSNumber)"
        return cell
        
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayHistorico.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
}

