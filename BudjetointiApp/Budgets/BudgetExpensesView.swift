//
//  BudgetExpensesView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 14.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct BudgetExpensesView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var showAddExpense = false
    @ObservedObject var expenses: Budget
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        
        return formatter
    }
    
    
    var body: some View {
        VStack {
            if expenses.expenseArray.isEmpty {
                Text("Tässä budjetissa ei ole menoja")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            else {
                List {
                    ForEach(expenses.expenseArray, id: \.self) { expense in
                        Section(header: Text("\(expense.wrappedDate, formatter: self.dateFormatter)")) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.wrappedExpenseName)
                                }
                                Spacer()
                                Text("\(expense.amount) €")
                            }
                        }
                    }
                        
                    .onDelete { index in
                        let deleteExpense = self.expenses.expenseArray[index.first!]
                        self.moc.delete(deleteExpense)
                           
                        try? self.moc.save()
                    }
                }
            }
        } .sheet(isPresented: $showAddExpense) {
            AddExpenseView(budget: self.expenses).environment(\.managedObjectContext, self.moc)
        }
    
        
        .navigationBarTitle(Text(expenses.wrappedName), displayMode: .inline)
    .navigationBarItems(trailing:
        Button(action: {
            self.showAddExpense.toggle()
        }) {
            Image(systemName: "plus.square.fill")
                .font(.largeTitle)
        }.foregroundColor(.blue))
        
        
    }
//        func deleteExpense(at offsets: IndexSet) {
//            for index in offsets {
//                let expense = expenses.expenseArray[index.first!]
//                print(expense)
//            }
//
//
//             // save the context
//             if self.moc.hasChanges {
//                 try? self.moc.save()
//             }
//         }
}

//struct BudgetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BudgetDetailView()
//    }
//}
