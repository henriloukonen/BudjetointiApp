//
//  ContentView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.2.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Expense.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Expense.date, ascending: true)
    ]) var expenses: FetchedResults<Expense>
    
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses, id: \.self) { expense in
                    HStack {
                        Text(expense.title ?? "unknown")
                            .font(.headline)
                       
                        Text(String(expense.amount))
                        
                        
                    }
                }
                .onDelete(perform: deleteExpenses)
            }
            
                
            .navigationBarTitle("Apin nimi")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingAddExpense.toggle()
            }) {
                Image(systemName: "plus")
            })
                .sheet(isPresented: $showingAddExpense) {
                    AddExpenseView().environment(\.managedObjectContext, self.moc)
            }
        }
}
    func deleteExpenses(at offsets: IndexSet) {
         for offset in offsets {
             // find this expense in our fetch request
             let expense = expenses[offset]
             
             // delete it from the context
             moc.delete(expense)
         }
         
         // save the context
         try? moc.save()
     }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
