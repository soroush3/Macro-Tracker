//
//  Date+CoreDataProperties.swift
//  Macro-Tracker
//
//  Created by Sherwin on 7/16/20.
//  Copyright © 2020 Sherwin. All rights reserved.
//
//

import Foundation
import CoreData


extension Date {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Date> {
        return NSFetchRequest<Date>(entityName: "Date")
    }

    @NSManaged public var date: String?
    @NSManaged public var foodItems: NSSet?

}

// MARK: Generated accessors for foodItems
extension Date {

    @objc(addFoodItemsObject:)
    @NSManaged public func addToFoodItems(_ value: FoodItem)

    @objc(removeFoodItemsObject:)
    @NSManaged public func removeFromFoodItems(_ value: FoodItem)

    @objc(addFoodItems:)
    @NSManaged public func addToFoodItems(_ values: NSSet)

    @objc(removeFoodItems:)
    @NSManaged public func removeFromFoodItems(_ values: NSSet)

}
