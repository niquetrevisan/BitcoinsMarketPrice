//
//  Point+CoreDataClass.swift
//  
//
//  Created by Monique Trevisan on 04/03/18.
//
//

import Foundation
import CoreData

@objc(Point)
public class Point: NSManagedObject {

}

extension Point {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Point> {
        return NSFetchRequest<Point>(entityName: "Point")
    }
    
    @NSManaged public var pointX: Double
    @NSManaged public var pointY: Double
    
}
