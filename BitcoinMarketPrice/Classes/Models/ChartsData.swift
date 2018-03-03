//
//  ChartsData.swift
//  BitcoinMarketPrice
//
//  Created by Monique Trevisan on 02/03/18.
//  Copyright © 2018 Monique Trevisan. All rights reserved.
//


//{
//    "status": "ok",
//    "name": "Confirmed Transactions Per Day",
//    "unit": "Transactions",
//    "period": "day",
//    "description": "The number of daily confirmed Bitcoin transactions.",
//    "values": [
//    {
//    "x": 1442534400, // Unix timestamp (2015-09-18T00:00:00+00:00)
//    "y": 188330.0
//    },
//    ...
//    }

import Foundation
import ObjectMapper

class ChartsData: Mappable {
    var status: String!
    var name: String!
    var unit: String!
    var period: String!
    var description: String!
    var chartValues: [ChartPoint]!
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        status <- map["status"]
        name <- map["name"]
        unit <- map["unit"]
        period <- map["period"]
        description <- map["description"]
        chartValues <- map["values"]
    }
    
}

class ChartPoint:Mappable {
    var pointX: NSNumber!
    var pointY: NSNumber!
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        pointX <- map["x"]
        pointY <- map["y"]
    }
}
