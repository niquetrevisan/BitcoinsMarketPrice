//
//  ChartsDataViewModel.swift
//  BitcoinMarketPrice
//
//  Created by Monique Trevisan on 02/03/18.
//  Copyright © 2018 Monique Trevisan. All rights reserved.
//

import UIKit
import Charts
import CoreData
import SwiftyJSON

enum MarketPriceError: Error {
    case loadLocalDataError
    case noItems
}

class MarketPriceViewModel: NSObject {

    var marketPrice: MarketPrice!
    weak var axisFormatDelegate: IAxisValueFormatter?
    var xLegend: Array<String>!
    var yLegend: Array<String>!
    
    func getChartsData(successBlock: @escaping (() -> ()), failureBlock: @escaping ((String) -> Void)) {
        
        axisFormatDelegate = self
        do {
            self.marketPrice = try loadLocalData()
            successBlock()
        } catch _ as NSError {
            self.loadMarketPriceDataFromServer(successBlock: { (marketPrice: MarketPrice) in
                self.marketPrice = marketPrice
                successBlock()
            }, failureBlock: { (error) in
                failureBlock(error)
            })
        }
    }
    
    //Busca dados do servidor se não houverem dados salvos
    func loadMarketPriceDataFromServer(successBlock: @escaping ((MarketPrice) -> ()), failureBlock: @escaping ((String) -> Void)) {
        MarketPriceProvider().getMarketPriceData(successBlock: { (jsonMarketPrice: JSON) in
            do {
                let marketPrice = try self.save(json: jsonMarketPrice)
                successBlock(marketPrice)
            }catch let error as NSError {
                failureBlock(error.description)
            }
        } , failureBlock: {(error: String) in
            failureBlock(error)
        })
    }
    
    func getLastMarketPrice() -> String {
        
        if let points = self.marketPrice?.points {
            let point = points[0] as! Point
            let value = String(format: "%.2f", point.pointY)
            return "$ \(value)"
        }
        
        return "Valor Indisponível"
    }
    
    //MARK : Métodos relacionados ao gráfico
    func configureLineChart(lineView: LineChartView){
        self.xLegend = [String]()
        var dataEntry = [ChartDataEntry]()
        for (index, point) in (self.marketPrice?.points?.enumerated())! {
            let pointY = (point as! Point).pointY
            let value = ChartDataEntry(x: Double(index), y: (point as! Point).pointY)
            let stringDate = self.unixFormatToData(unixDate: "\((point as! Point).pointX )")
            self.xLegend.append(stringDate)
            dataEntry.append(value)
        }
        
        let dataSet = LineChartDataSet(values: dataEntry, label: "Cotações diárias dos últimos 30 dias")
        let data = LineChartData(dataSets: [dataSet])
        
        lineView.data = data
        lineView.chartDescription?.text = "Valores em USD"
        
        let xaxis = lineView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
    }
    
    //Format data
    func unixFormatToData(unixDate: String) -> String {
        let date = NSDate(timeIntervalSince1970: Double(unixDate)!)
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .short
        dateformatter.timeStyle = .none
        
        let now = dateformatter.string(from: date as Date)
        
        return now
    }
    
    //MARK: Métodos relacionados ao Core Data
    func save(json: JSON) throws -> MarketPrice {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MarketPrice", in: managedContext!)!
        let market = NSManagedObject(entity: entity, insertInto: managedContext) as! MarketPrice
        market.convertJsonToObjetc(json: json, context: managedContext)
        if market.points?.count == 0 {
            throw MarketPriceError.noItems
        }
        do {
            try managedContext?.save()
            return market
        } catch let error as NSError {
            throw error
        }
    }
    
    func loadLocalData() throws -> MarketPrice {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                throw MarketPriceError.loadLocalDataError
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MarketPrice")
        
        do {
            let data = try managedContext.fetch(fetchRequest)
            if data.count > 0 {
                return data[0] as! MarketPrice
            }
            else { throw MarketPriceError.noItems }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            throw MarketPriceError.loadLocalDataError
        }
    }
    
}

// axisFormatDelegate
extension MarketPriceViewModel: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        
        return self.xLegend[index]
    }
}
