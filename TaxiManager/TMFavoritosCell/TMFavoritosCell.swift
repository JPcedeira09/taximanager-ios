//
//  TMFavoritosCell.swift
//  TaxiManager
//
//  Created by Esdras Martins on 01/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit

class TMFavoritosCell: UITableViewCell {

    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelEndereco1: UILabel!
    @IBOutlet weak var labelEndereco2: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
