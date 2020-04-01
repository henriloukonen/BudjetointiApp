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
    
    @State private var showingWelcomeViewAddBudget = false
    @State private var showingBudgets = false
    @State private var showingSettings = false
    @State private var showingContextMenuAddExpense = false
    @State private var showDetail = false
    
    init() {

       UITableView.appearance().separatorStyle = .none //remove separators

    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(budgets, id: \.self) { budget in
                    NavigationLink(destination: BudgetExpensesView(expenses: budget)) {
                        HStack {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    DurationTimer(duration: budget.duration, startDate: budget.wrappedStartDate)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        
                                    Text("jäljellä")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                            }
                            
                            Text(budget.wrappedName)
                                .font(.largeTitle)
                            Spacer()
                        }
                        .contextMenu {
                            VStack {
                                Button("Lisää uusi meno") {
                                    self.showingContextMenuAddExpense = true
                                } .sheet(isPresented: self.$showingContextMenuAddExpense) {
                                    AddExpenseView(budget: budget).environment(\.managedObjectContext, self.moc)
                                }
                            }
                        }
                        
                        Text("\(self.remaining(in: budget)) €")
                            .bold()
                        
                    }.frame(height: 50)
                        .padding()
                    
                } 
                .environment(\.defaultMinListRowHeight, 50)
                .listRowBackground(
                    Rectangle()
                        .foregroundColor(budgetRowColor())
                        .cornerRadius(15)
                        .padding(EdgeInsets(top: 6, leading: 17, bottom: 6, trailing: 17))
                        .clipShape(Capsule())
                        .opacity(0.5)
                )
                
                VStack {
                              Button(action: {
                                  withAnimation(.spring()) {
                                      self.showDetail.toggle()
                                  }
                              }) {
                                  VStack {
                                      Image(systemName: "chevron.right.circle").font(.system(size: 50))
                                          .rotationEffect(.degrees(showDetail ? -90 : 0))
                                        
                                      
                                      if self.showDetail {
                                        Text("Detail").transition(
                                            AnyTransition.move(edge: .bottom).combined(with: .opacity)
                                        )
                                      }
                                      Spacer()
                                  }
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
                                ShowBudgetsView().environment(\.managedObjectContext, self.moc)
                        }
                    }.foregroundColor(.blue)
            })
                .navigationBarTitle("Yleisnäkymä")
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
                .padding(0)
            
            if horizontalSizeClass == .regular {
                IpadWelcomeView()
            }
        }
    }
    
    func budgetRowColor() -> Color {
        return .blue
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
