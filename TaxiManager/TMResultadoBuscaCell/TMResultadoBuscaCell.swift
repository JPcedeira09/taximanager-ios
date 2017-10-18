//
//  TMResultadoBuscaCell.swift
//  TaxiManager
//
//  Created by Esdras Martins on 17/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit

class TMResultadoBuscaCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var imgViewLogo: UIImageView!
    
    @IBOutlet weak var labelNome: UILabel!
    
    @IBOutlet weak var labelEspera: UILabel!
    
    @IBOutlet weak var labelPreco: UILabel!
    
    
    @IBOutlet weak var btnIr: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
