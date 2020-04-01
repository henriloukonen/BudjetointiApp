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
    @State private var showingEditExpense = false
    
    @ObservedObject var expenses: Budget
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        return formatter
    }
    
    
    var body: some View {
        
        VStack {
            List {
                if expenses.expenseArray.isEmpty {
                    Text("Tässä budjetissa ei ole menoja")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                else {
                    ForEach(expenses.expenseArray, id: \.self) { expense in
                        NavigationLink(destination: EditExpenseView(expense: expense).environment(\.managedObjectContext, self.moc)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(expense.amount) €")
                                        .font(.headline)
                                    
                                    Text(expense.wrappedExpenseNote)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text("\(expense.wrappedDate, formatter: self.dateFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete { index in
                        let deleteExpense = self.expenses.expenseArray[index.first!]
                        self.moc.delete(deleteExpense)
                        
                        try? self.moc.save()
                    }
                }
            } .listStyle(GroupedListStyle())
                .animation(.easeInOut)
            
            VStack {
                Button("Uusi meno") {
                    self.showAddExpense.toggle()
                    } .buttonStyle(CustomButton())
            }
            
        }
        
        .sheet(isPresented: $showAddExpense) {
            AddExpenseView(budget: self.expenses).environment(\.managedObjectContext, self.moc)
        }
            
        .navigationBarTitle(Text(expenses.wrappedName), displayMode: .inline)
        
        
        
    }
}

//struct BudgetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BudgetDetailView()
//    }
//}
