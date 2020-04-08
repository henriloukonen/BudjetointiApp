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
    @FetchRequest(entity: Budget.entity(), sortDescriptors: [])
    
    var allBudgets: FetchedResults<Budget>
    
    @State private var showAddExpense = false
    @State private var showAddIncome = false
    @State private var showBudgets = false
    @State private var showEditExpense = false
    
    @ObservedObject var budget: Budget
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        return formatter
    }
    
    
    var body: some View {
        VStack {
            List {
                if budget.expenseArray.isEmpty {
                    Text("Tämä budjetti on tyhjä")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                else {
                    ForEach(budget.expenseArray, id: \.self) { expense in
                        NavigationLink(destination: EditExpenseView(editExpense: EditExpenseModel(expense: expense)).environment(\.managedObjectContext, self.moc)) {
                            HStack {
                                Image(systemName: expense.isExpense ? "chevron.up" : "chevron.down")
                                    .foregroundColor(expense.isExpense ? .red : .green)
                                    .padding(.horizontal, 5)
                                VStack(alignment: .leading) {
                                    Text("\(expense.amount) €")
                                        .font(.headline)
                                    HStack {
                                        Text(expense.wrappedExpenseNote)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    
                                }
                                
                                Spacer()
                                
                                Text("\(expense.wrappedDate, formatter: self.dateFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            
                            //.simultaneousGesture(
                            //                            TapGesture()
                            //                                .onEnded { _ in
                            //                                    self.showEditExpense.toggle()
                            //                            }
                            //                        )
                            //
                            //                            .sheet(isPresented: self.$showEditExpense) {
                            //                                EditExpenseView(editExpense: EditExpenseModel(expense: expense)).environment(\.managedObjectContext, self.moc)
                            //                        }
                        }
                        
                    }
                    .onDelete { index in
                        withAnimation(.spring()) {
                            if self.budget.expenseArray[index.first!].isTransfer {
                                for item in self.allBudgets {
                                    for expense in item.expenseArray {
                                        if expense.isTransfer && expense.transferID == self.budget.expenseArray[index.first!].transferID {
                                            let deleteTransfer = item.expenseArray[index.first!]
                                            self.moc.delete(deleteTransfer)
                                        }
                                    }
                                }
                            }
                            else {
                                let deleteExpense = self.budget.expenseArray[index.first!]
                                self.moc.delete(deleteExpense)
                            }
                            if self.moc.hasChanges {
                                try? self.moc.save()
                            }
                        }
                    }
                } 
            }
            .listStyle(GroupedListStyle())
            
            HStack {
                HStack {
                    VStack {
                        Button(action: {
                            self.showAddExpense.toggle()
                        }) {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width:30, height: 30)
                        }
                        .sheet(isPresented: self.$showAddExpense) {
                            AddExpenseView(budget: self.budget).environment(\.managedObjectContext, self.moc)
                        }
                        .modifier(RoundButton(color: .green, size: (25, 25)))
                        
                        Text("Lisää")
                            .font(.footnote)
                    } .padding(.horizontal, 20)
                    VStack {
                        Button(action: {
                            //
                        }) {
                            NavigationLink(destination: BudgetStatsView(budgetDetails: budget)) {
                                Image(systemName: "chevron.right.2")
                                    .resizable()
                                    .frame(width:30, height: 30)
                            }
                        }
                        .modifier(RoundButton(color: .purple, size: (25, 25)))
                        
                        Text("Yhteenveto")
                            .font(.footnote)
                        
                    }
                }
            }
        }
            
        .navigationBarTitle(Text(budget.wrappedName), displayMode: .inline)
    }
}

//struct BudgetDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//
//        BudgetDetailView()
//    }
//}
