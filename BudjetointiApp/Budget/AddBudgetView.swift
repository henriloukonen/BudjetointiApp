//
//  AddBudgetView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct AddBudgetView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    
    @State private var budgetName = ""
    @State private var budgetAmount = ""
    @State private var budgetDuration = 0
    @State private var startDate = Date()
    
    var durationText = ["Joka viikko", "Joka kuukausi", "Joka vuosi"]
    
    var durationAmount: Int16 {
        var duration = Int16(0)
        
        switch budgetDuration {
        case 0:
            duration = 7
        case 1:
            duration = 30
        case 2:
            duration = 365
        default:
            duration = 1
        }
        
        return duration
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Perustiedot")) {
                    TextField("Nimi", text: $budgetName)
                    TextField("Budjetin määrä", text: $budgetAmount)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Kesto"), footer: Text("Valitse kuinka usein budjetti alkaa alusta")) {
                    Picker(selection: $budgetDuration, label: Text("kesto")) {
                        ForEach(0 ..< durationText.count) {
                            Text(self.durationText[$0])
                        }
                        
                    } .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarItems(trailing: Button(action: {
                
                let newBudget = Budget(context: self.moc)
                newBudget.name = self.budgetName
                newBudget.budgetAmount = Int16(self.budgetAmount) ?? 0
                newBudget.duration = self.durationAmount
                newBudget.startDate = self.startDate
                newBudget.id = UUID()
                
                if self.moc.hasChanges {
                    try? self.moc.save()
                }
                
                self.presentationMode.wrappedValue.dismiss()
                
            }, label: {
                Text("Tallenna")
            })
                .disabled(budgetName.isEmpty || budgetAmount.isEmpty)
            )
            .navigationBarTitle("Uusi")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

//struct NewBudgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewBudgetView(budgets: budgets)
//    }
//}
