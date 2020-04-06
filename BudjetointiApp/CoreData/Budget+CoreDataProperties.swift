//
//  Budget+CoreDataProperties.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 31.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var budgetAmount: Int32
    @NSManaged public var duration: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var expenses: NSSet?

     public var wrappedName: String {
         name ?? "Nimetön budjetti"
     }
     
     public var wrappedStartDate: Date {
         startDate ?? Date()
     }
    
     public var expenseArray: [Expense] {
         let set = expenses as? Set<Expense> ?? []
         return set.sorted {
             $0.wrappedDate < $1.wrappedDate
         }
     }
}

// MARK: Generated accessors for expenses
extension Budget {

    @objc(addExpensesObject:)
    @NSManaged public func addToExpenses(_ value: Expense)

    @objc(removeExpensesObject:)
    @NSManaged public func removeFromExpenses(_ value: Expense)

    @objc(addExpenses:)
    @NSManaged public func addToExpenses(_ values: NSSet)

    @objc(removeExpenses:)
    @NSManaged public func removeFromExpenses(_ values: NSSet)

}
