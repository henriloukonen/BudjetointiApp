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
    
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
  
    
    var budget: Budget
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Nimi", text: $name)
                    TextField("Summa", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                DatePicker(selection: $date, displayedComponents: .date) {
                    Text("Päivä")
                } .pickerStyle(WheelPickerStyle())
                
            }
                
            .navigationBarTitle(Text(budget.wrappedName), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                let newExpense = Expense(context: self.moc)
                newExpense.name = self.name
                newExpense.amount = Int16(self.amount) ?? 0
                newExpense.date = self.date
                newExpense.selectedBudget = self.budget
                
                if self.moc.hasChanges {
                    try? self.moc.save()
                }
                
                self.presentationMode.wrappedValue.dismiss()
            })
            {
                Text("Tallenna")
            }
            .disabled(name.isEmpty || amount.isEmpty)
            )
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
