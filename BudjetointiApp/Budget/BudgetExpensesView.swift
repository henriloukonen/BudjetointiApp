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
    @State private var showAddIncome = false
    @State private var showBudgets = false
    
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
                    Text("Tässä budjetissa ei ole menoja tai tuloja")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .transition(.slide)
                }
                else {
                    ForEach(budget.expenseArray, id: \.self) { expense in
                        NavigationLink(destination: EditExpenseView(expense: expense).environment(\.managedObjectContext, self.moc)) {
                            HStack {
                                Image(systemName: expense.isExpense ? "chevron.up" : "chevron.down")
                                    .foregroundColor(expense.isExpense ? .red : .green)
                                    .padding(.horizontal, 5)
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
                        withAnimation(.spring()) {
                            let deleteExpense = self.budget.expenseArray[index.first!]
                            self.moc.delete(deleteExpense)
                            
                            try? self.moc.save()
                        }
                    } .transition(
                        AnyTransition.move(edge: .trailing).combined(with: .opacity)
                    )
                }
            } .listStyle(GroupedListStyle())
            
            
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
                        .frame(width: 150, height: 30)
                        .padding(.all)
                        .background(Color.green)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                        .font(Font.body.bold())
                        
                        Text("Lisää")
                            .font(.footnote)
                    } .padding(.horizontal, 4)
                    VStack {
                        Button(action: {
                            //
                        }) {
                            NavigationLink(destination: MoreExpenseDetailsView(budgetDetails: budget)) {
                                Image(systemName: "chevron.right.2")
                                    .resizable()
                                    .frame(width:30, height: 30)
                            }
                        }
                        .frame(width: 150, height: 30)
                        .padding(.all)
                        .background(Color.purple)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                        .font(Font.body.bold())
                        
                        Text("Yksityiskohdat")
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
//        BudgetDetailView()
//    }
//}
