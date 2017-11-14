//
//  TMHistoricoViewCell.swift
//  TaxiManager
//
//  Created by Esdras Martins on 30/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit
import ExpandableCell

class TMHistoricoViewCell :  UITableViewCell{

    
    @IBOutlet weak var imgViewLogo: UIImageView!
    @IBOutlet weak var labelCorrida: UILabel!
    @IBOutlet weak var labelOrigem: UILabel!
    @IBOutlet weak var labelDestino: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
