//
//  TMCustomTableViewHeaderTableViewCell.swift
//  TaxiManager
//
//  Created by Esdras Martins on 31/10/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import UIKit

class TMCustomTableViewHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewLogo: UIImageView!
    @IBOutlet weak var labelTitulo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
