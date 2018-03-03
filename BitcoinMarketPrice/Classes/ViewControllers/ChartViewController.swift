//
//  ViewController.swift
//  BitcoinMarketPrice
//
//  Created by Monique Trevisan on 26/02/18.
//  Copyright © 2018 Monique Trevisan. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {

    var chartViewModel:ChartsDataViewModel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadChartData()
        
    }

    //MARK: Load method
    
    func loadChartData(){
        self.chartViewModel = ChartsDataViewModel()
        self.chartViewModel.getChartsData(successBlock: {
            print("sucesso")
        }) { (error) in
            
            print(error)
            
            
        }
        
    }

}

