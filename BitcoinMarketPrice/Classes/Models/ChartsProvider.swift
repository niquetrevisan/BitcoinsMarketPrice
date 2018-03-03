//
//  ChartsProvider.swift
//  BitcoinMarketPrice
//
//  Created by Monique Trevisan on 02/03/18.
//  Copyright © 2018 Monique Trevisan. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class ChartsProvider: NSObject {

    func getChartData(successBlock: @escaping ((ChartsData) -> ()), failureBlock: @escaping ((String) -> Void), timestamp: String) {
        let URL = "https://api.blockchain.info/charts/"
        Alamofire.request(URL).responseObject { (response: DataResponse<ChartsData>) in
            
            if (response.error != nil) {
                failureBlock(response.error.debugDescription)
            }
            else {
                successBlock(response.value!)
            }
            
        }
        
        
    }
    
}
