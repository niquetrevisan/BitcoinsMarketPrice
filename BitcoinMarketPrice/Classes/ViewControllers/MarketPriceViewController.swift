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
        self.marketPriceViewModel = MarketPriceViewModel()
        self.loadChartData()
    }

    //MARK: Load method
    func loadChartData(){
        self.showLoadingView()
        self.marketPriceViewModel.getChartsData(successBlock: {
            self.loadingView.removeFromSuperview()
            self.showChart()
        }) { (error) in
            self.loadingView.removeFromSuperview()
            let alert = UIAlertController(title: "Desculpe!", message: "Não foi possível carregar os dados.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

    //Apresentar dados no gráfico
    func showChart() {
        self.lbMarketPriceDay.text = self.marketPriceViewModel.getLastMarketPrice()
        self.marketPriceViewModel.configureLineChart(lineView: self.lineChartView)
    }
    
    func showLoadingView() {
        if self.loadingView == nil {
            self.loadingView = UIView.fromNib()
        }
        self.loadingView.frame = self.view.frame
        self.view.addSubview(self.loadingView)
    }
    
    @IBAction func reloadDataServer(sender: UIBarButtonItem) {
        self.showLoadingView()
        self.marketPriceViewModel.loadMarketPriceDataFromServer(successBlock: { (marketPrice) in
            self.loadingView.removeFromSuperview()
            self.showChart()
        }) { (error) in
            self.loadingView.removeFromSuperview()
            let alert = UIAlertController(title: "Desculpe!", message: "Não foi possível carregar os dados.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
            }
        }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed("LoadingView", owner: nil, options: nil)![0] as! T
    }
}
