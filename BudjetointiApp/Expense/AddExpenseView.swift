//
//  AddExpenseView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.2.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI
import Combine

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var budget: Budget

    @State private var expenseNote = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var isExpense = true
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Muistiinpano", text: $expenseNote)
                    TextField("Summa", text: $amount)
                        .keyboardType(.decimalPad)
//                        .modifier(CheckForNumbers(textField: amount))
                        .onReceive(Just(amount)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.amount = filtered
                            }
                        }
                }
                
                DatePicker(selection: $date, in: ...Date()) {
                    Text("Päivä ja aika")
                } .pickerStyle(WheelPickerStyle())
                
                Section  {
                    HStack {
                        Toggle(isOn: $isExpense) {
                            Text("Meno")
                        }
                    }
                }
                    
                .navigationBarTitle(isExpense ? Text("Uusi meno: \(budget.wrappedName)") : Text("Uusi tulo: \(budget.wrappedName)"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "x.circle")
                    
                    }, trailing: Button("Tallenna") {
                        let newExpense = Expense(context: self.moc)
                        
                        newExpense.date = self.date
                        newExpense.selectedBudget = self.budget
                        newExpense.note = self.expenseNote
                        newExpense.amount = Int32(self.amount) ?? 0
                        newExpense.id = UUID()
                        newExpense.isExpense = self.isExpense
                        newExpense.isTransfer = false
               
                        if self.moc.hasChanges {
                            try? self.moc.save()
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(amount.isEmpty))
            }
            
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
