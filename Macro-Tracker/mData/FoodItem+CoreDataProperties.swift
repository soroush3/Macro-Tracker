//
//  FoodItem+CoreDataProperties.swift
//  Macro-Tracker
//
//  Created by Sherwin on 7/16/20.
//  Copyright © 2020 Sherwin. All rights reserved.
//
//

import Foundation
import CoreData


extension FoodItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodItem> {
        return NSFetchRequest<FoodItem>(entityName: "FoodItem")
    }

    @NSManaged public var cals: Int16
    @NSManaged public var carbs: Int16
    @NSManaged public var fat: Int16
    @NSManaged public var identifier: UUID?
    @NSManaged public var name: String?
    @NSManaged public var protein: Int16
    @NSManaged public var theDate: Date?

}
