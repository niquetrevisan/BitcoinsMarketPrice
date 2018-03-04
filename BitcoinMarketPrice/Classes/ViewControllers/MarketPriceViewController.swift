//
//  ViewController.swift
//  BitcoinMarketPrice
//
//  Created by Monique Trevisan on 26/02/18.
//  Copyright © 2018 Monique Trevisan. All rights reserved.
//

import UIKit
import Charts

class MarketPriceViewController: UIViewController {

    @IBOutlet weak var lbMarketPriceDay: UILabel!
    var marketPriceViewModel:MarketPriceViewModel!
    @IBOutlet var lineChartView: LineChartView!
    var loadingView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView = UIView.fromNib()
        self.marketPriceViewModel = MarketPriceViewModel()
        self.view.addSubview(self.loadingView)
        self.loadChartData()
    }

    //MARK: Load method
    func loadChartData(){
        
        self.marketPriceViewModel.getChartsData(successBlock: {
            self.showChart()
            self.loadingView.removeFromSuperview()
        }) { (error) in
            self.loadingView.removeFromSuperview()
        }
    }

    func showChart() {
        self.lbMarketPriceDay.text = self.marketPriceViewModel.getLastMarketPrice()
        self.marketPriceViewModel.configureLineChart(lineView: self.lineChartView)
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed("LoadingView", owner: nil, options: nil)![0] as! T
    }
}
