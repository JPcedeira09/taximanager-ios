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
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.expandableDelegate = self
        
        self.tableView.register(UINib(nibName: "TMHistoricoViewCell", bundle: nil), forCellReuseIdentifier: "tmHistoricoCell")
        self.tableView.register(UINib(nibName: "TMHistoricoVerMaisCell", bundle: nil), forCellReuseIdentifier: "tmHistoricoDetalheCell")
    }
    //MARK: - Metodos
    
    //MARK: - Actions
    

    @IBAction func fechar(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension TMHistoricoViewController : ExpandableDelegate{
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        
        return [430.0]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        let cell = expandableTableView.dequeueReusableCell(withIdentifier: "tmHistoricoDetalheCell")!
        return [cell]
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = expandableTableView.dequeueReusableCell(withIdentifier: "tmHistoricoCell", for: indexPath) as! TMHistoricoViewCell
        return cell
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
}

