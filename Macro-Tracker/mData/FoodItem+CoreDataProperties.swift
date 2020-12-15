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

    @NSManaged public var cals: Int64
    @NSManaged public var carbs: Int64
    @NSManaged public var fat: Int64
    @NSManaged public var foodName: String?
    @NSManaged public var identifier: UUID
    @NSManaged public var protein: Int64
    @NSManaged public var date: String?

}
