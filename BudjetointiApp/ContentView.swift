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
    @FetchRequest(entity: Budget.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Budget.name, ascending: true),
    ])
    
    var budgets: FetchedResults<Budget>
    
    @State private var showingSettings = false
    @State private var showBudgets = false
    @State private var showAddExpense = false
    @State private var showMenu = false
    @State private var showTransfer = false
    
    init() {
        UITableView.appearance().separatorStyle = .none //remove separators
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    if budgets.isEmpty {
                        VStack {
                            Text("Tyhjää on")
                                .padding(10)
                                .font(.largeTitle)
                                .padding()
                            Text("Lisää uusi budjetti alla olevasta valikosta")
                                .foregroundColor(.gray)
                        }
                    }
                    else {
                        List {
                            ForEach(budgets, id: \.self) { budget in
                                NavigationLink(destination: BudgetExpensesView(budget: budget).environment(\.managedObjectContext, self.moc)) {
                                    HStack(alignment: .center) {
                                        VStack(alignment: .leading) {
                                            VStack(alignment: .leading) {
                                                DurationTimer(duration: budget.duration, startDate: budget.wrappedStartDate)
                                                    .font(.footnote)
                                            }
                                            .padding()
                                        }
                                        
                                        BudgetRowBackground(budget: budget)
                                                .mask(Text(budget.wrappedName).font(.largeTitle))
                                        Spacer()
                                    }
                                    
                                    Text("\(Calculate().remainingBalance(in: budget)) €")
                                        .bold()
                                } 
                                .frame(height: 40)
                                .padding()
                            }
                            .environment(\.defaultMinListRowHeight, 40)
                            .blur(radius: self.showMenu ? 10 : 0)
                        }
                        .disabled(showMenu)
                        
                    }
                    
                    Spacer()
                    BottomMenuView(showMenu: $showMenu, showBudgets: $showBudgets, showTransfer: $showTransfer)
                }
            }
                
            .sheet(isPresented: $showBudgets) {
                ShowBudgetsView().environment(\.managedObjectContext, self.moc)
                
            }
            .navigationBarItems(leading:
                Button(action: {
                    self.showingSettings.toggle()
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .sheet(isPresented: $showingSettings) {
                            SettingsView()
                    }
                }
                .background(
                    EmptyView()
                        .sheet(isPresented: self.$showTransfer) {
                            TransferBudgetBalanceView().environment(\.managedObjectContext, self.moc)
                })
            )
                .navigationBarTitle("Yleisnäkymä")
                .padding(0)
            
            if horizontalSizeClass == .regular {
                IpadWelcomeView()
            }
        }
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(budget: Budget)
//    }
//}
