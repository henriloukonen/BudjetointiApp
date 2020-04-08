//
//  EditModel.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 6.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import Foundation

class EditBudgetModel: ObservableObject {
    @Published var newName: String
    @Published var newAmount: String
    @Published var budget: Budget
    @Published var expenses: [Expense]
    
    
    init(budget: Budget) {
        self.budget = budget
        self.newName = budget.wrappedName
        self.newAmount = String(budget.budgetAmount)
        self.expenses = budget.expenseArray
    }
}


class EditExpenseModel: ObservableObject {
    @Published var newNote: String
    @Published var newAmount: String
    @Published var newDate: Date
    @Published var expense: Expense
    

    init(expense: Expense) {
        self.newNote = expense.wrappedExpenseNote 
        self.newAmount = String(expense.amount)
        self.newDate = expense.wrappedDate
        self.expense = expense
       
    }
}
