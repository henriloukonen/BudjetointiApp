//
//  BudgetCalculations.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 4.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import Foundation

class Calculate {
    func remainingBalance(in budget: Budget) -> Int32 {
        var remaining = budget.budgetAmount
        
        for expense in budget.expenseArray {
            if expense.isExpense {
                remaining -= expense.amount
            }
            else {
               remaining += expense.amount
            }
        }
        
        return remaining
    }
    
    func totalSpent(in budget: Budget) -> Int {
        var spent = 0
        
        for expense in budget.expenseArray {
            if expense.isExpense {
                spent += Int(expense.amount)
            }
        }
        return spent
    }
    
    func totalReceived(in budget: Budget) -> Int {
        var received = 0
        
        for expense in budget.expenseArray {
            if !expense.isExpense {
                received += Int(expense.amount)
            }
        }
        return received
    }
    
    func totalEvents(in budget: Budget) -> Int {
        var events = 0
        
        for _ in budget.expenseArray {
            events += 1
        }
        return events
    }
}

