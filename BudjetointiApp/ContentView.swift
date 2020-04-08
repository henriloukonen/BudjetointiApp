//
//  ContentView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.2.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @FetchRequest(entity: Budget.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Budget.name, ascending: true),
    ])
    
    var budgets: FetchedResults<Budget>
    
    
    @State private var showSettings = false
    @State private var showBudgets = false
//    @State private var showAddExpense = false
    @State private var showMenu = false
    @State private var showTransfer = false
//    @State private var isUnlocked = false
    
    init() {
        UITableView.appearance().separatorStyle = .none //remove separators
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                //if self.isUnlocked {
                VStack {
                    Spacer()
                    if budgets.isEmpty {
                        VStack {
                            Text("Tyhjää on")
                                .padding(10)
                                .padding(.horizontal, 4)
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
                                                TimerView(duration: budget.duration, startDate: budget.wrappedStartDate)
                                                    .font(.footnote)
                                                }
                                                .padding(.trailing, 4)
                                        } .frame(minWidth: 40, maxWidth: 80)
                                        
                                        VStack(alignment: .leading) {
                                            Text(budget.wrappedName)
                                                .font(.largeTitle)
                                        }
                                        
                                        Spacer()
                                    }
                                    HStack {
                                        Text("\(Calculate().remainingBalance(in: budget)) €")
                                            .bold()
                                            .background(balanceColor(budget: budget))
                                        } .frame(minWidth: 50)
                                }
                                .frame(height: 40)
                                .padding(2)
                            }
                            .environment(\.defaultMinListRowHeight, 40)
                            .blur(radius: self.showMenu ? 10 : 0)
                        }
                        .disabled(showMenu)
                    }
                    
                    Spacer()
                    BottomMenuView(showMenu: $showMenu, showBudgets: $showBudgets, showTransfer: $showTransfer)
                }
            } .onDisappear {
                self.showMenu = false
            }
                //.onAppear(perform: authenticate)
                .sheet(isPresented: $showBudgets) {
                    ShowBudgetsView().environment(\.managedObjectContext, self.moc)
                    
            }
            .navigationBarItems(leading:
                Button(action: {
                    withAnimation(.spring()) {
                        self.showSettings.toggle()
                        self.showMenu = false
                    }
                    
                }) {
                    Image(systemName: "slider.horizontal.3")
                        .sheet(isPresented: $showSettings) {
                            SettingsView()
                    }
                }
                .background(
                    EmptyView()
                        .sheet(isPresented: self.$showTransfer) {
                            TransferBudgetBalanceView().environment(\.managedObjectContext, self.moc)
                })
            )
                .navigationBarTitle(showMenu ? "" : "Yleisnäkymä")
                .padding(0)
            
            if horizontalSizeClass == .regular {
                IpadWelcomeView()
            }
        }
    }
    //    func authenticate() {
    //        let context = LAContext()
    //        var error: NSError?
    //
    //        // check whether biometric authentication is possible
    //        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
    //            // it's possible, so go ahead and use it
    //            let reason = "Tätä tarvitaan budjettien näyttämiseen."
    //
    //            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
    //                // authentication has now completed
    //                DispatchQueue.main.async {
    //                    if success {
    //                        self.isUnlocked = true
    //                    } else {
    //                        print("ei onnistunut")
    //                    }
    //                }
    //            }
    //        } else {
    //            // no biometrics
    //        }
    //    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(budget: Budget)
//    }
//}
