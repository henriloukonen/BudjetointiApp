//
//  AddExpenseView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.2.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var expenseNote = ""
    @State private var amount = ""
    @State private var date = Date()
    
    @ObservedObject var budget: Budget
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Muistiinpano", text: $expenseNote)
                    TextField("Summa", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                DatePicker(selection: $date, in: ...Date()) {
                    Text("Päivä ja aika")
                } .pickerStyle(WheelPickerStyle())
       
            }
                
            .navigationBarTitle(Text(budget.wrappedName), displayMode: .inline)
            .navigationBarItems(trailing: Button("Tallenna") {
                
                let newExpense = Expense(context: self.moc)
                newExpense.note = self.expenseNote
                newExpense.amount = Int16(self.amount) ?? 0
                newExpense.date = self.date
                newExpense.selectedBudget = self.budget
                newExpense.id = UUID()
                
                if self.moc.hasChanges {
                    try? self.moc.save()
                }
                
                self.presentationMode.wrappedValue.dismiss()
            }
            .disabled(amount.isEmpty))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
//
//struct AddExpenseView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddExpenseView(budgets: Budget)
//    }
//}
