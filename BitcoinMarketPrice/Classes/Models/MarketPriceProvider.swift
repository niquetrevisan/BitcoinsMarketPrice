//
//  ChartsProvider.swift
//  BitcoinMarketPrice
//
//  Created by Monique Trevisan on 02/03/18.
//  Copyright © 2018 Monique Trevisan. All rights reserved.
//

import Foundation
import Alamofire
import CoreData
import SwiftyJSON

class MarketPriceProvider: NSObject {
    let URL = "https://api.blockchain.info/charts/market-price?timespan=4week&format=json"
    func getMarketPriceData(successBlock: @escaping ((JSON) -> ()), failureBlock: @escaping ((String) -> Void)) {
        Alamofire.request(URL).responseJSON(completionHandler: { (jsonData) in
            if (jsonData.error != nil) {
                    failureBlock(jsonData.error.debugDescription)
                }
            else {
                let json = JSON(jsonData.value!)
                successBlock(json)
            }
        })
    }
    
}
