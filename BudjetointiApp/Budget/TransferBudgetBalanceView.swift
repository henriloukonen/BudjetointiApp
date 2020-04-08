//
//  TransferBudgetBalanceView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 3.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI
import Combine

struct TransferBudgetBalanceView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity: Budget.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Budget.name, ascending: true),
    ])
    
    var budgets: FetchedResults<Budget>
    var transferID = UUID()
    
    @State private var showDestination = false
    @State private var showSource = true
    @State private var showNumberField = false
    @State private var sourceText = ""
    @State private var destinationText = ""
    @State private var amountField = ""
    @State private var sourceAmount = 0
    @State private var destinationAmount = 0
    @State private var date = Date()
    
    @State private var sourceID: Budget?
    @State private var destinationID: Budget?
    
    
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
                    Section(header: Text(showSource ? "Mistä budjetista siirretään?" : "Mihin budjettiin siirretään?")) {
                        if showSource {
                            List(budgets, id: \.self) { sourceBudget in
                                
                                Button(sourceBudget.wrappedName) {
                                        self.sourceText = sourceBudget.wrappedName
                                        self.showSource = false
                                        self.showDestination = true
                                        self.sourceID = sourceBudget
                                }
                                Spacer()
                                HStack {
                                    Text("\(Calculate().remainingBalance(in: sourceBudget)) €")
                                }
                            }
                        }
                    }
                    if showDestination {
                        List(budgets.filter({!$0.wrappedName.contains(self.sourceText)}), id: \.self) { destinationBudget in
                            Button(destinationBudget.wrappedName) {
                                
                                self.showDestination = false
                                self.showNumberField = true
                                self.destinationText = destinationBudget.wrappedName
                                self.destinationID = destinationBudget
                            }
                            Spacer()
                            HStack {
                                Text("\(Calculate().remainingBalance(in: destinationBudget)) €")
                            }
                        }
                    }
                    if !showSource {
                        Section {
                            Button(action: {
                                self.sourceText = ""
                                self.amountField = ""
                                self.showSource = true
                                self.showDestination = false
                                self.showNumberField = false
                                
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left.2")
                                        .padding(.trailing, 4)
                                    Text("Valitse uudestaan")
                                        .bold()
                                        .font(.headline)
                                }
                            }
                        }
                    }
                    if showNumberField {
                        Section {
                            HStack {
                                Spacer()
                                Text(sourceText)
                                    .font(.headline)
                                Image(systemName: "chevron.right.2")
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 4)
                                Text(destinationText)
                                
                                Spacer()
                            }
                            
                            Divider()
                            TextField("Summa", text: $amountField)
                                .keyboardType(.decimalPad)
                                .onReceive(Just(amountField)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.amountField = filtered
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
                }, trailing: Button("Siirrä") {
                    withAnimation(.spring()) {
                        let source = Expense(context: self.moc)
                        source.note = "Siirto: \(self.destinationText)"
                        source.amount = Int32(self.amountField) ?? 0
                        source.date = self.date
                        source.selectedBudget = self.sourceID
                        source.isExpense = true
                        source.transferID = self.transferID
                        source.isTransfer = true
                        
                        let destination = Expense(context: self.moc)
                        destination.note = "Siirto: \(self.sourceText)"
                        destination.amount = Int32(self.amountField) ?? 0
                        destination.date = self.date
                        destination.selectedBudget = self.destinationID
                        destination.isExpense = false
                        destination.transferID = self.transferID
                        destination.isTransfer = true
                        
                        if self.moc.hasChanges {
                            try? self.moc.save()
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                } .disabled(amountField.isEmpty))
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct FilteredBudgets: View {
//    var fetchRequest: FetchRequest<Budget>
//    @Binding var showNumberField: Bool
//    @Binding var destinationBudget: Budget
//
//    init(filter: String, numberField: Bool) {
//        fetchRequest = FetchRequest<Budget>(entity: Budget.entity(), sortDescriptors: [], predicate: NSPredicate(format: "NOT (name MATCHES %@)", filter))
//        showNumberField = numberField
//
//    }
//
//    var body: some View {
//        List(fetchRequest.wrappedValue, id: \.self) { budget in
//            HStack {
//                VStack(alignment: .leading) {
//                    Button(budget.wrappedName) {
//                        self.showNumberField = true
//                        self.destinationBudget = budget
//                    }
//                }
//                Spacer()
//                Text("\(Calculate().remainingBalance(in: budget))")
//            }
//
//        }
//    }
//}
//
//struct TransferBudgetBalanceView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransferBudgetBalanceView()
//    }
//}
