//
//  MobiliteeDevice.swift
//  TaxiManager
//
//  Created by Esdras Martins on 14/11/17.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony

struct MBDevice : Codable{

    var id : String = UIDevice.current.identifierForVendor!.uuidString
    var operation_system : String = "ios"
    var operation_system_version : String = UIDevice.current.systemVersion
    var device : String = UIDevice.current.modelName
    var type_connection : String = getNetworkType()
    var version_app : String =  Bundle.main.releaseVersionNumberPretty


    static func getNetworkType() -> String {
        
        if let reachability = Reachability.forInternetConnection() {
            reachability.startNotifier()
            let status = reachability.currentReachabilityStatus()
            if status == .init(0) {
                // .NotReachable
                print("Not Reachable")
            }
            else if status == .init(1) {
                // .ReachableViaWiFi
                return "wifi"
                
            }
            else if status == .init(2) {
                // .ReachableViaWWAN
                let netInfo = CTTelephonyNetworkInfo()
                if let cRAT = netInfo.currentRadioAccessTechnology  {
                    switch cRAT {
                    case CTRadioAccessTechnologyGPRS,
                         CTRadioAccessTechnologyEdge,
                         CTRadioAccessTechnologyCDMA1x:
                        
                        return "2g"
                    case CTRadioAccessTechnologyWCDMA,
                         CTRadioAccessTechnologyHSDPA,
                         CTRadioAccessTechnologyHSUPA,
                         CTRadioAccessTechnologyCDMAEVDORev0,
                         CTRadioAccessTechnologyCDMAEVDORevA,
                         CTRadioAccessTechnologyCDMAEVDORevB,
                         CTRadioAccessTechnologyeHRPD:
                        
                        return "3g"
                        
                    case CTRadioAccessTechnologyLTE:
                        
                        return "4g"
                    default:
                        return ""
                    }
                }
            }
        }
        return ""
    }
}
