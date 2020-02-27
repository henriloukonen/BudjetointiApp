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
    
    @State private var title = ""
    @State private var category = ""
    @State private var categories = ["testi", "testi 2", "testi 3"]
    @State private var amount = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Nimi", text: $title)
                    Picker("Kategoria", selection: $category) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section {
                    TextField("Määrä", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationBarTitle("Lisää")
            .navigationBarItems(trailing: Button(action: {
                let newExpense = Expense(context: self.moc)
                newExpense.title = self.title
                newExpense.amount = Int16(self.amount) ?? 0
                
                
                try? self.moc.save()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Tallenna")
            })
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView()
    }
}
