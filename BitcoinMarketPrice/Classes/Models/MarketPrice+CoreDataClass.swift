//
//  MarketPrice+CoreDataClass.swift
//  
//
//  Created by Monique Trevisan on 04/03/18.
//
//

import Foundation
import CoreData
import SwiftyJSON

public class MarketPrice: NSManagedObject {
}

extension MarketPrice {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MarketPrice> {
        return NSFetchRequest<MarketPrice>(entityName: "MarketPrice")
    }
    
    @NSManaged public var desc: String?
    @NSManaged public var name: String?
    @NSManaged public var period: String?
    @NSManaged public var status: String?
    @NSManaged public var unit: String?
    @NSManaged public var points: NSOrderedSet?
    
}

extension MarketPrice {
    struct Keys {
        static let name = "name"
        static let desc = "description"
        static let period = "period"
        static let status = "status"
        static let unit = "unit"
        static let points = "values"
    }
    
    public func convertJsonToObjetc(json: JSON, context: NSManagedObjectContext?) {
        
        desc = json[Keys.name].string
        name = json[""].string
        period = json[""].string
        status = json[""].string
        unit = json[""].string
        let pointsArray = json[Keys.points].array
        let pointsdSet = NSMutableOrderedSet.init()
        
        for point in pointsArray! {
            let entityDescription = NSEntityDescription.entity(forEntityName: "Point", in: context!)!
            let p = Point(entity: entityDescription, insertInto: context)
            p.pointX = point["x"].double ?? 0
            p.pointY = point["y"].double ?? 0
            pointsdSet.add(p)
        }
        
        self.addToPoints(pointsdSet)
    }
}

// MARK: Generated accessors for points
extension MarketPrice {
    
    @objc(insertObject:inPointsAtIndex:)
    @NSManaged public func insertIntoPoints(_ value: Point, at idx: Int)
    
    @objc(removeObjectFromPointsAtIndex:)
    @NSManaged public func removeFromPoints(at idx: Int)
    
    @objc(insertPoints:atIndexes:)
    @NSManaged public func insertIntoPoints(_ values: [Point], at indexes: NSIndexSet)
    
    @objc(removePointsAtIndexes:)
    @NSManaged public func removeFromPoints(at indexes: NSIndexSet)
    
    @objc(replaceObjectInPointsAtIndex:withObject:)
    @NSManaged public func replacePoints(at idx: Int, with value: Point)
    
    @objc(replacePointsAtIndexes:withPoints:)
    @NSManaged public func replacePoints(at indexes: NSIndexSet, with values: [Point])
    
    @objc(addPointsObject:)
    @NSManaged public func addToPoints(_ value: Point)
    
    @objc(removePointsObject:)
    @NSManaged public func removeFromPoints(_ value: Point)
    
    @objc(addPoints:)
    @NSManaged public func addToPoints(_ values: NSOrderedSet)
    
    @objc(removePoints:)
    @NSManaged public func removeFromPoints(_ values: NSOrderedSet)
    
}
