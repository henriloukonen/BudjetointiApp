//
//  ContentView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.2.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @FetchRequest(entity: Budget.entity(), sortDescriptors: [])
    
    var budgets: FetchedResults<Budget>
   
    @State private var showingWelcomeViewAddBudget = false
    @State private var showingBudgets = false
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            ZStack {
                if budgets.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        Text("Tyhjää on")
                            .font(.largeTitle)
                        Spacer()
                        Text("Tee uusi budjetti napauttamalla alla olevaa nappia")
                            .foregroundColor(.gray)
                            .font(.headline)
                        
                        Button(action: {
                            self.showingWelcomeViewAddBudget.toggle()
                        }) {
                            Image(systemName: "plus.square.fill")
                                .font(.largeTitle)
                        }.foregroundColor(.green)
                        Spacer()
                    }
                    
                }
                else {
                    List {
                        ForEach(budgets, id: \.self) { budget in
                            HStack {
                                VStack(alignment: .leading) {
                                    NavigationLink(destination: BudgetExpensesView(expenses: budget)) {
                                        Text(budget.wrappedName)
                                            .font(.largeTitle)
                                    }
                                }
                                Spacer()
                                
                                Text("\(self.remaining(in: budget)) €")
                                    .bold()
                                
                            }.frame(height: 40)
                            .padding()
                            
                        }
                        .environment(\.defaultMinListRowHeight, 40)
                        .listRowBackground(Color.blue)
                    }
                    .onAppear {
                        UITableView.appearance().separatorStyle = .none
                    }.onDisappear {
                        UITableView.appearance().separatorStyle = .singleLine
                    }
                }

            }
            .navigationBarItems(leading:
            HStack {
                Button(action: {
                    self.showingSettings.toggle()
                }) {
                    Image(systemName: "gear")
                        .font(.largeTitle)
                    
                        .sheet(isPresented: $showingSettings) {
                            SettingsView()
                    }
                }.foregroundColor(.gray)
            }, trailing:
            HStack {
                Button(action: {
                    self.showingBudgets.toggle()
                }) {
                    Image(systemName: "tray.2.fill")
                        .font(.largeTitle)
                    
                        .sheet(isPresented: $showingBudgets) {
                            ShowBudgetsView(budgets: self.budgets).environment(\.managedObjectContext, self.moc)
                    }
                }.foregroundColor(.blue)
            })
                .sheet(isPresented: $showingWelcomeViewAddBudget) {
                    AddBudgetView().environment(\.managedObjectContext, self.moc)
            }
            .navigationBarTitle("Yleisnäkymä")
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .padding(0)
            
            if horizontalSizeClass == .regular {
                WelcomeView()
            }
        }
    }
    func remaining(in budget: Budget) -> Int16 {
        var remaining = budget.budgetAmount
        
        for expense in budget.expenseArray {
            remaining = remaining - expense.amount
        }
        
        return remaining
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(budget: Budget)
//    }
//}
