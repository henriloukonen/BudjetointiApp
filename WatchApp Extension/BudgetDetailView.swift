//
//  BudgetDetailView.swift
//  WatchApp Extension
//
//  Created by Henri Loukonen on 2.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct BudgetDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var budget: Budget
    
    var body: some View {
        ForEach(budget.expenseArray, id: \.self) { expense in
            HStack {
                Text(expense.wrappedExpenseNote)
                Text("\(expense.amount)")
            }
        }
        
    }
}

//struct BudgetDetailView_Previews: PreviewProvider {
//    let budget: Budget
//    static var previews: some View {
//        BudgetDetailView(budget: budget)
//    }
//}
