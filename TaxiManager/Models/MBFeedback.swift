//
//  Feedback.swift
//  TaxiManager
//
//  Created by joao cedeira on 13/12/2017.
//  Copyright © 2017 Taxi Manager. All rights reserved.
//

import Foundation


struct MBFeedback {
    
   /* {
    "userId": 0,
    "subject": "string",
    "message": "string",
    "platform": "string",
    "platformVersion": "string",
    "appVersion": "string",
    "latitude": 0,
    "longitude": 0
    }*/
    
    var userId:Int = 0
    var subject:String = ""
    var message:String = ""
    var platform:String = "IOS"
    var platformVersion = "11.2"
    var appVersion:String = "1.4"
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    init ( userId : Int , subject:String , message: String , platform: String, platformVersion:String, appVersion:String, latitude:Double, longitude:Double ){
        self.userId = userId
        self.subject = subject
        self.message = message
        self.platform = platform
        self.platformVersion = platformVersion
        self.appVersion = appVersion
        self.latitude = latitude
        self.longitude = longitude

    }
    
    init(serializable: [String:Any]){
        self.userId = serializable["userId"] as? Int ?? 0
        self.subject = serializable["subject"] as? String ?? ""
        self.message = serializable["message"] as? String ?? ""
        self.platform = serializable["platform"] as? String ?? ""
        self.platformVersion = serializable["platformVersion"] as? String ?? ""
        self.appVersion = serializable["appVersion"] as? String ?? ""
        self.latitude = serializable["latitude"] as? Double ?? 0.0
        self.longitude = serializable["longitude"] as? Double ?? 0.0
    }
    
    func toDict(_ feedback : MBFeedback) -> [String: Any]{
        let parametros = ["userId" :  feedback.userId, "subject" :  feedback.subject, "message" : feedback.message, "platform" : feedback.platform ,"platformVersion" : feedback.platformVersion, "appVersion" : feedback.appVersion, "latitude" : feedback.latitude, "longitude" : feedback.longitude] as [String : Any]
        return parametros
    }
    
}
