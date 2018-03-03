//
//  ChartsDataViewModel.swift
//  BitcoinMarketPrice
//
//  Created by Monique Trevisan on 02/03/18.
//  Copyright © 2018 Monique Trevisan. All rights reserved.
//

import UIKit

class ChartsDataViewModel: NSObject {

    var chartData: ChartsData!
    
    func getChartsData(successBlock: @escaping (() -> ()), failureBlock: @escaping ((String) -> Void)) {
        
        ChartsProvider().getChartData(successBlock: { (chartData: ChartsData) in
            self.chartData = chartData
            successBlock()
        }, failureBlock: {(error: String) in
            failureBlock(error)
        }, timestamp: "")
    }
    
    
}
