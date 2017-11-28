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
    
//    var arrayHistorico = [[String:Any]]()
    
    
    var historyList = [MBTravel]()
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.expandableDelegate = self
        
        self.tableView.register(UINib(nibName: "TMHistoricoViewCell", bundle: nil), forCellReuseIdentifier: "tmHistoricoCell")
        self.tableView.register(UINib(nibName: "TMHistoricoVerMaisCell", bundle: nil), forCellReuseIdentifier: "tmHistoricoDetalheCell")
        
//        let defaults = UserDefaults.standard
        if let historico = MBUser.currentUser?.history{
            
            historyList = historico
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
        
        let registro = self.historyList[indexPath.row]
        
        cell.lblDistancia.text = "\(registro.distance) km"
        cell.lblDuracao.text = ""
        cell.lblValor.text = "R$\(registro.cost)"
        cell.lblFornecedor.text = registro.player.name
        cell.lblCategoria.text =  registro.player.category.name
        cell.lblCentroCusto.text = registro.costCentre.name
        cell.lblProjeto.text = registro.project ?? ""
        cell.lblJustificativa.text = ""
        
        return [cell]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = expandableTableView.dequeueReusableCell(withIdentifier: "tmHistoricoCell") as! TMHistoricoViewCell
        
        let registro = self.historyList[indexPath.row]
        
        cell.labelOrigem.text = registro.startAddress
        cell.labelDestino.text = registro.endAddress
        cell.labelCorrida.text = registro.player.category.name  + " - R$" + "\(registro.cost)"
        return cell
        
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.historyList.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
}

