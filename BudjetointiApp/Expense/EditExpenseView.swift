//
//  EditExpenseView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI


struct EditExpenseView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expense: Expense
    
    @State private var newNote: String
    @State private var newAmount: String
    @State private var newDate: Date
    
    init(expense: Expense) {
        self.expense = expense

        self._newNote = State(initialValue: expense.wrappedExpenseNote) //_newName - this means you're initialising the wrapper and not the wrapped value.
        self._newAmount = State(initialValue: String(expense.amount))
        self._newDate = State(initialValue: expense.wrappedDate)
        
      
        
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField(newNote == "" ? "Muistiinpano" : newNote, text: $newNote)
                    
                }
                HStack {
                    TextField(String(newAmount), text: $newAmount)
                        .keyboardType(.decimalPad)
                }
            }
            Section {
                DatePicker(selection: $newDate, in: ...Date()) {
                    Text("Päivä ja aika")
                }
                .pickerStyle(WheelPickerStyle())
            }
        }
            
        .navigationBarItems(trailing: Button("Tallenna") {
            self.expense.note = self.newNote
            self.expense.amount = Int16(self.newAmount)!
            self.expense.date = self.newDate
            
            
            if self.moc.hasChanges {
                try? self.moc.save()
            }
        } .disabled(newAmount.isEmpty))
            
            .navigationBarTitle(Text(expense.wrappedExpenseNote), displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
        
    }
}
//
//struct EditExpenseView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditExpenseView(selectedExpense: selectedExpense)
//    }
//}
