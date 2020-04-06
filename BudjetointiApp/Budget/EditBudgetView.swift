//
//  EditBudgetView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI
import Combine

struct EditBudgetView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newName: String
    @State private var newAmount: String
    @State private var creationDate: Date
    @State private var showConfirmation = false
    
    @ObservedObject var selectedBudget: Budget
    
    init(selectedBudget: Budget) {
        self.selectedBudget = selectedBudget
        self._newName = State(initialValue: selectedBudget.wrappedName) //_newName - this means you're initialising the wrapper and not the wrapped value.
        self._newAmount = State(initialValue: String(selectedBudget.budgetAmount))
        self._creationDate = State(initialValue: selectedBudget.wrappedStartDate)
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        return formatter
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
        ZStack {
            List {
                Section {
                    HStack {
                        Text("Nimi")
                            .bold()
                        
                        TextField(newName, text: $newName)
                    }
                    HStack {
                        Text("Summa")
                            .bold()
                        TextField(String(newAmount), text: $newAmount)
                            .keyboardType(.decimalPad)
                            .onReceive(Just(newAmount)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.newAmount = filtered
                                }
                        }
                    }
                    HStack {
                        Text("Jäljellä")
                            .bold()
                        Text("\(Calculate().remainingBalance(in: selectedBudget))")
                        
                    }.foregroundColor(.gray)
                        .disabled(true)
                    HStack {
                        Text("Kesto")
                            .bold()
                        Text(durationText)
                    }.foregroundColor(.gray)
                    .disabled(true)
                    HStack {
                        Text("Luontipäivä")
                            .bold()
                        Text("\(creationDate, formatter: dateFormatter)")
                    }.foregroundColor(.gray)
                    .disabled(true)
                }
            } .disabled(showConfirmation)
                .blur(radius: showConfirmation ? 20 : 0)
            ConfirmationAlertView(showConfirmation: self.$showConfirmation)
        }
        .navigationBarItems(trailing: Button("Tallenna") {
            withAnimation(.spring()) {
                self.selectedBudget.name = self.newName
                self.selectedBudget.budgetAmount = Int32(self.newAmount) ?? 30
                
                self.showConfirmation.toggle()
                
                if self.moc.hasChanges {
                    try? self.moc.save()
                }
            }
                
            
            
        } .disabled(newAmount == String(selectedBudget.budgetAmount) && newName == selectedBudget.wrappedName || (newAmount.isEmpty || newName.isEmpty)))
            
            .navigationBarTitle(Text(selectedBudget.wrappedName), displayMode: .inline)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct EditBudgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditBudgetView()
//    }
//}
