//
//  TransferBudgetBalanceView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 3.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct TransferBudgetBalanceView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: Budget.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Budget.name, ascending: true),
    ])
    
    var budgets: FetchedResults<Budget>
    @State private var sourceText = ""
    @State private var destinationText = ""
    @State private var showDestination = true
    @State private var buttonDisabled = true

    
    var body: some View {
        NavigationView {
            Form {
                if budgets.count < 2 {
                    Section {
                        Text("Ei tarpeeksi budjetteja siirtoa varten.")
                            .foregroundColor(.gray)
                            .bold()
                    }
                }
                else {
                    Section(header: Text("Mistä budjetista siirretään?")) {
                        ForEach(budgets, id: \.self) { budget in
                            NavigationLink(destination: MakeTransferView(source: budget).environment(\.managedObjectContext, self.moc)) {
                                HStack {
                                    Text(budget.wrappedName)
                                    Spacer()
                                    HStack {
                                        Text("\(Calculate().remainingBalance(in: budget)) €")
                                    }
                                }
                            }
                        }
                    }
                }
            }
                
            .navigationBarTitle("Siirto")
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "x.circle")
                })
        }
    }
}
//
//struct TransferBudgetBalanceView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransferBudgetBalanceView()
//    }
//}
