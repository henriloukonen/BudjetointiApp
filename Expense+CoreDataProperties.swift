//
//  Expense+CoreDataProperties.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 14.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var selectedBudget: Budget?

    public var wrappedExpenseName: String {
        name ?? "Nimetön kulu"
    }
    
    public var wrappedDate: Date {
        date ?? Date()
    }
    
}
