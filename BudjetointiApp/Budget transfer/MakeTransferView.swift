//
//  MakeTransferView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 4.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct MakeTransferView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    
    @ObservedObject var source: Budget
    
    @State private var buttonDisabled = true
    @State private var amount = ""
    @State private var destination = ""
    
    var body: some View {
        
        Form {
            Section(header: Text("Mihin siirretään?")) {
                FilteredBudget(filter: source.wrappedName)
                
              
            }
            Section(header: Text("Määrä")) {
               
                    TextField("Summa", text: $amount)
                        .keyboardType(.decimalPad)
                     
            }
            
            Text(amount.isEmpty ? "Kirjoita siirrettävä summa" : "Olet siirtämässä \(amount) euroa budjetista \(source.wrappedName) budjettiin paska")
                .font(.callout)
        }
            
        .navigationBarTitle(Text(source.wrappedName), displayMode: .inline)
        .navigationBarItems(trailing: Button("Siirrä") {
            
            //            newExpense.amount = Int32(self.amount) ?? 0
            //            newExpense.date = self.date
            //            newExpense.selectedBudget = self.budget
            
            if self.moc.hasChanges {
                try? self.moc.save()
            }
        } .disabled(buttonDisabled))
        
    }
    
    func calculateDifference() -> Int32 {
        return 32
    }
}

struct FilteredBudget: View {
    var fetchRequest: FetchRequest<Budget>
    
    init(filter: String) {
        fetchRequest = FetchRequest<Budget>(entity: Budget.entity(), sortDescriptors: [], predicate: NSPredicate(format: "NOT (name MATCHES %@)", filter))
    }
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { budget in
            HStack {
                VStack(alignment: .leading) {
                    Button(budget.wrappedName) {
                        
                    }
                }
                Spacer()
                Text("\(Calculate().remainingBalance(in: budget)) €")
            }
            
        }
    }
}
//
//struct TransferBudgetView_Previews: PreviewProvider {
//    var source: Budget
//    static var previews: some View {
//        MakeTransferView(source: source)
//    }
//}
