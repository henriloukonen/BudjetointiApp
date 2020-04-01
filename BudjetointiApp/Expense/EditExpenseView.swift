//
//  EditExpenseView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

class EditViewModel: ObservableObject {
    @Published var newNote: String
    @Published var newAmount: String
    @Published var newTime: Date
    @Published var newDate: Date
    @Published var expense: Expense
    
    init(expense: Expense) {
        self.expense = expense
        self.newNote = expense.wrappedExpenseNote //_newName - this means you're initialising the wrapper and not the wrapped value.
        self.newAmount = String(expense.amount)
        self.newTime = expense.wrappedTime
        self.newDate = expense.wrappedDate
    }
}

struct EditExpenseView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var editModel: EditViewModel

    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        
                        TextField(editModel.newNote == "" ? "Muistiinpano" : editModel.newNote, text: $editModel.newNote)
                            
                    }
                    HStack {
                        TextField("Summa", text: $editModel.newAmount)
                            .keyboardType(.decimalPad)
                            
                    }
                }
                Section {
                    DatePicker(selection: $editModel.newDate, in: ...Date()) {
                            Text("Päivä")
                        }
                            .pickerStyle(WheelPickerStyle())
                           
                }
            }
            
      
                
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Sulje")
                }),
                    trailing: Button(action: {
                        self.editModel.expense.note = self.editModel.newNote
                        self.editModel.expense.amount = Int16(self.editModel.newAmount)!
                        self.editModel.expense.date = self.editModel.newDate
                        self.editModel.expense.time = self.editModel.newTime
                    
                        
                        if self.moc.hasChanges {
                            try? self.moc.save()
                        }
                }) {
                        Text("Tallenna")
                }
                    .disabled(editModel.newAmount.isEmpty)
            )
                
                .navigationBarTitle(Text(editModel.newNote), displayMode: .inline)
        
        .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
//
//struct EditExpenseView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditExpenseView(selectedExpense: selectedExpense)
//    }
//}
