//
//  TMHistoricoVerMaisCell.swift
//  TaxiManager
//
//  Created by Esdras Martins on 30/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit

class TMHistoricoVerMaisCell: UITableViewCell {

    @IBOutlet weak var lblDistancia: CustomLabel!
    @IBOutlet weak var lblDuracao: CustomLabel!
    @IBOutlet weak var lblValor: CustomLabel!
    @IBOutlet weak var lblFornecedor: CustomLabel!
    @IBOutlet weak var lblCategoria: CustomLabel!
    @IBOutlet weak var lblCentroCusto: CustomLabel!
    @IBOutlet weak var lblProjeto: CustomLabel!
    @IBOutlet weak var lblJustificativa: CustomLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
