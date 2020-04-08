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
    
    @ObservedObject var editExpense: EditExpenseModel
    @State private var showConfirmation = false
    
    var body: some View {
        
        ZStack {
            Form {
                Section {
                    HStack {
                        TextField("Muistiinpano", text: $editExpense.newNote)
                    }
                    .disabled(editExpense.expense.isTransfer)
                    .foregroundColor(editExpense.expense.isTransfer ? .gray : .none)
                    HStack {
                        TextField("määrä", text: $editExpense.newAmount)
                            .keyboardType(.decimalPad)
                            .onReceive(Just(editExpense.newAmount)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.editExpense.newAmount = filtered
                                }
                        }
                    }
                }
                Section {
                    DatePicker(selection: $editExpense.newDate, in: ...Date()) {
                        Text("Päivä ja aika")
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            .blur(radius: showConfirmation ? 10 : 0)
            .disabled(showConfirmation)
            .navigationBarItems(trailing:
                Button("Tallenna") {
                    withAnimation(.spring()) {
                        self.editExpense.expense.note = self.editExpense.newNote
                        self.editExpense.expense.amount = Int32(self.editExpense.newAmount) ?? 0
                        self.editExpense.expense.date = self.editExpense.newDate
                        
                        self.showConfirmation.toggle()
                        
                        if self.moc.hasChanges {
                            try? self.moc.save()
                        }
                    }
                } .disabled(editExpense.newAmount.isEmpty || (editExpense.newAmount == String(editExpense.expense.amount) && editExpense.newNote == editExpense.expense.wrappedExpenseNote && editExpense.newDate == editExpense.expense.wrappedDate)))
                
                .navigationBarTitle(Text(editExpense.expense.wrappedExpenseNote), displayMode: .inline)
                .navigationViewStyle(StackNavigationViewStyle())
            
            ConfirmationAlertView(showConfirmation: self.$showConfirmation)
            
        }
            
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//
//struct EditExpenseView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditExpenseView(selectedExpense: selectedExpense)
//    }
//}
