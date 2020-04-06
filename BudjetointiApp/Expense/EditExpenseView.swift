//
//  EditExpenseView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI
import Combine

struct EditExpenseView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expense: Expense
    
    @State private var newNote: String
    @State private var newAmount: String
    @State private var newDate: Date
    @State private var showConfirmation = false
    
    init(expense: Expense) {
        self.expense = expense
        
        self._newNote = State(initialValue: expense.wrappedExpenseNote) //_newName - this means you're initialising the wrapper and not the wrapped value.
        self._newAmount = State(initialValue: String(expense.amount))
        self._newDate = State(initialValue: expense.wrappedDate)
    }
    
    var body: some View {
        ZStack {
            Form {
                Section {
                    HStack {
                        TextField(newNote == "" ? "Muistiinpano" : newNote, text: $newNote)
                    }
                    HStack {
                        TextField(String(newAmount), text: $newAmount)
                            .keyboardType(.decimalPad)
                            .onReceive(Just(newAmount)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.newAmount = filtered
                                }
                        }
                    }
                }
                Section {
                    DatePicker(selection: $newDate, in: ...Date()) {
                        Text("Päivä ja aika")
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            } .blur(radius: showConfirmation ? 10 : 0)
                .disabled(showConfirmation)
                
            .navigationBarItems(trailing: Button("Tallenna") {
                withAnimation(.spring()) {
                    self.expense.note = self.newNote
                    self.expense.amount = Int32(self.newAmount) ?? 0
                    self.expense.date = self.newDate

                    self.showConfirmation.toggle()
                    
                    if self.moc.hasChanges {
                        try? self.moc.save()
                    }
                }
            } .disabled(newAmount.isEmpty || (newAmount == String(expense.amount) && newNote == expense.wrappedExpenseNote && newDate == expense.wrappedDate)))
                
                .navigationBarTitle(Text(expense.wrappedExpenseNote), displayMode: .inline)
                .navigationViewStyle(StackNavigationViewStyle())
            
            ConfirmationAlertView(showConfirmation: self.$showConfirmation)
        }
        
    }
}

//
//struct EditExpenseView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditExpenseView(selectedExpense: selectedExpense)
//    }
//}
