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
    
    @State private var newName: String
    @State private var newAmount: String
    @State private var disableEditing = true
    @State private var creationDate: Date
    
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
                    HStack {
                        Text("Luontipäivä")
                            .bold()
                            .foregroundColor(.gray)
                        Text("\(creationDate, formatter: dateFormatter)")
                            .foregroundColor(.gray)
                    }
                }
                Section {
                    VStack(alignment: .center, spacing: 10) {
                        Button(disableEditing ? "Muokkaa" : "Lopeta muokkaus") {
                            self.disableEditing.toggle()
                        } .foregroundColor(.blue)
                            .font(.headline)
                    }
                    
                }
                
            } .foregroundColor(disableEditing ? Color.gray : Color.black)
                
                .navigationBarItems(trailing: Button("Tallenna") {
                    self.selectedBudget.name = self.newName
                    self.selectedBudget.budgetAmount = Int16(self.newAmount) ?? self.selectedBudget.budgetAmount
                    
                    if self.moc.hasChanges {
                        try? self.moc.save()
                    }
                } .disabled(disableEditing || (newAmount.isEmpty || newName.isEmpty))
            )
                
        .navigationBarTitle(Text(selectedBudget.wrappedName), displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct EditBudgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditBudgetView()
//    }
//}
