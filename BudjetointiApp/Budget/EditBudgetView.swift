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
    
    //    @State private var newName: String
    //    @State private var newAmount: String
    //    @State private var creationDate: Date
    @State private var showConfirmation = false
    
    @ObservedObject var editBudget: EditBudgetModel
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        return formatter
    }
    
    var durationText: String {
        var duration = ""
        
        switch editBudget.budget.duration {
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
                        HStack {
                            Text("Nimi")
                                .bold()
                        }.frame(minWidth: 100)
                        Divider()
                        
                        TextField("Nimi", text: $editBudget.newName)
                    }
                    HStack {
                        HStack {
                            Text("Summa")
                                .bold()
                        }.frame(minWidth: 100)
                        Divider()
                        TextField("Summa", text: $editBudget.newAmount)
                            .keyboardType(.decimalPad)
                        
                    }
                    HStack {
                        HStack {
                            Text("Jäljellä")
                                .bold()
                        }.frame(minWidth: 100)
                        Divider()
                        Text("\(Calculate().remainingBalance(in: editBudget.budget))")
                        
                    }
                    .foregroundColor(.gray)
                    .disabled(true)
                    HStack {
                        HStack {
                            Text("Kesto")
                                .bold()
                        }.frame(minWidth: 100)
                        Divider()
                        
                        Text(durationText)
                    }
                    .foregroundColor(.gray)
                    .disabled(true)
                    HStack {
                        HStack {
                            Text("Luontipäivä")
                                .bold()
                        }.frame(minWidth: 100)
                        Divider()
                        
                        Text("\(editBudget.budget.wrappedStartDate, formatter: dateFormatter)")
                    }
                    .foregroundColor(.gray)
                    .disabled(true)
                }
            } .disabled(showConfirmation)
                .blur(radius: showConfirmation ? 20 : 0)
            ConfirmationAlertView(showConfirmation: self.$showConfirmation)
        }
        .navigationBarItems(trailing: Button("Tallenna") {
            withAnimation(.spring()) {
                self.editBudget.budget.name = self.editBudget.newName
                self.editBudget.budget.budgetAmount = Int32(self.editBudget.newAmount) ?? 0
                
                self.showConfirmation.toggle()
                
                if self.moc.hasChanges {
                    try? self.moc.save()
                }
            }
            
            
            
        } .disabled(editBudget.newAmount == String(editBudget.budget.budgetAmount) && editBudget.newName == editBudget.budget.wrappedName || (editBudget.newName.isEmpty || editBudget.newAmount.isEmpty)))
            
            .navigationBarTitle(Text(editBudget.budget.wrappedName), displayMode: .inline)
    }
}

//struct EditBudgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditBudgetView()
//    }
//}
