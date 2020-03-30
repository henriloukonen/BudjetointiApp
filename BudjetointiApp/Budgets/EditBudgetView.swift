//
//  EditBudgetView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct EditBudgetView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newName = ""
    @State private var newAmount = ""
    @State private var disableEditing = true
    
    @ObservedObject var selectedBudget: Budget
    
    init(selectedBudget: Budget) {
        self.selectedBudget = selectedBudget
        self._newName = State(initialValue: selectedBudget.wrappedName) //_newName - this means you're initialising the wrapper and not the wrapped value.
        self._newAmount = State(initialValue: String(selectedBudget.budgetAmount))
    }
    
    var durationText: String {
        var duration = ""
        
        switch selectedBudget.duration {
        case 7:
            duration = "Viikottain"
        case 30:
            duration = "Kuukausittain"
        case 365:
            duration = "Vuosittain"
        default:
            duration = "Päivittäin"
        }
        
        return duration
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Nimi")
                            .bold()
                        TextField(newName, text: $newName)
                            .disabled(disableEditing)
                    }
                    HStack {
                        Text("Budjetti")
                            .bold()
                        TextField(String(newAmount), text: $newAmount)
                            .disabled(disableEditing)
                            .keyboardType(.decimalPad)
                    }
                    HStack {
                        Text("Kesto")
                            .bold()
                            .foregroundColor(.gray)
                        Text(durationText)
                            .foregroundColor(.gray)
                    }
                }
                
            }
            
            .foregroundColor(disableEditing ? Color.gray : Color.black)
                
                .navigationBarItems(leading: Button(action: {
                    self.disableEditing.toggle()
                }, label: {
                    Text("Muokkaa")
                }),
                    trailing: Button(action: {
                    
                    
                    self.selectedBudget.name = self.newName
                    self.selectedBudget.budgetAmount = Int16(self.newAmount) ?? self.selectedBudget.budgetAmount
                    
                    if self.moc.hasChanges {
                        try? self.moc.save()
                    }

                  self.presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    if disableEditing || (newAmount == String(selectedBudget.budgetAmount) && newName == selectedBudget.wrappedName) {
                        Text("Sulje")
                    }
                    else {
                        Text("Tallenna")
                    }
                        
                })
                    .disabled(newAmount.isEmpty || newName.isEmpty)
            )
                
                .navigationBarTitle(selectedBudget.wrappedName)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct EditBudgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditBudgetView()
//    }
//}
