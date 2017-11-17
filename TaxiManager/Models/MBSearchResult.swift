//
//  MBSearchDetail.swift
//  TaxiManager
//
//  Created by Esdras Martins on 17/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation


struct MBSearchResult {
    
    var startAddress : MBLocation
    var endAddress : MBLocation
    var duration : Int
    var distance : Int
    var travels : [MBRide]
    
}
