//
//  Expense+CoreDataProperties.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 4.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Int32
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var note: String?
    @NSManaged public var time: Date?
    @NSManaged public var isExpense: Bool
    @NSManaged public var selectedBudget: Budget?

    public var wrappedExpenseNote: String {
         note ?? ""
     }
     
     public var wrappedDate: Date {
         date ?? Date()
     }
     
     public var wrappedTime: Date {
         time ?? Date()
     }
}
