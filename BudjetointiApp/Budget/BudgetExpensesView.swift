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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
                if horizontalSizeClass == .regular {
                    VStack {
                        Text("lol")
                    }
                }
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
                
            
            VStack {
                Button("Uusi meno") {
                    self.showAddExpense.toggle()
                }
                    .frame(minWidth: 0, maxWidth: 130, minHeight: 0, maxHeight: 50)
                    .background(Color.green)
                    .cornerRadius(11)
                    .foregroundColor(.white)
                    .font(Font.body.bold())
            }
        }
        .sheet(isPresented: $showAddExpense) {
            AddExpenseView().environment(\.managedObjectContext, self.moc)
        }
            
        .navigationBarTitle(Text(expenses.wrappedName), displayMode: .inline)
    }
}

//struct BudgetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BudgetDetailView()
//    }
//}
