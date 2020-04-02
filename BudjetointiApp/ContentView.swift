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
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @FetchRequest(entity: Budget.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Budget.name, ascending: true),
    ])
    
    var budgets: FetchedResults<Budget>
   
    @State private var showingMainPageAddExpense = false
    @State private var showingBudgets = false
    @State private var showingSettings = false
    @State private var showDetail = false
    
    init() {
        UITableView.appearance().separatorStyle = .none //remove separators
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(budgets, id: \.self) { budget in
                            NavigationLink(destination: BudgetExpensesView(expenses: budget)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        VStack(alignment: .leading) {
                                            DurationTimer(duration: budget.duration, startDate: budget.wrappedStartDate)
                                                .font(.footnote)
                                            Text("jäljellä")
                                                .font(.footnote)
                                        }
                                        .padding()
                                    }
                                    
                                    Text(budget.wrappedName)
                                        .font(.largeTitle)
                                    Spacer()
                                }
                                .sheet(isPresented: self.$showingMainPageAddExpense) {
                                    AddExpenseView().environment(\.managedObjectContext, self.moc)
                                }

                                Text("\(self.remainingBalance(in: budget)) €")
                                    .bold()
                                
                            }.frame(height: 50)
                                .padding()
                            
                        }
                        .environment(\.defaultMinListRowHeight, 50)
                        .listRowBackground(
                            Rectangle()
                                .fill(
                                    LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(15)
                                .padding(EdgeInsets(top: 6, leading: 17, bottom: 6, trailing: 17))
                                .clipShape(Capsule())
                                .opacity(0.7)
                        )
                    }
                    Spacer()
                    
                    VStack {
                        if self.showDetail {
                            VStack(alignment: .center) {
                                Button(action: {
                                    self.showingBudgets.toggle()
                                }) {
                                    Text("Kaikki Budjetit")
                                    Image(systemName: "line.horizontal.3")
                                        .padding(.horizontal, 2)
                                }
                                .sheet(isPresented: self.$showingBudgets) {
                                    ShowBudgetsView().environment(\.managedObjectContext, self.moc)
                                }
                                .frame(width: 150, height: 30)
                                .padding(.all)
                                .background(Color.blue)
                                .cornerRadius(20)
                                .foregroundColor(.white)
                                .font(Font.body.bold())
                                
                                Button(action: {
                                    self.showingMainPageAddExpense.toggle()
                                }) {
                                    Text("Uusi meno")
                                    Image(systemName: "pencil")
                                        .padding(.horizontal, 2)
                                }
                                .frame(width: 150, height: 30)
                                .padding(.all)
                                .background(Color.green)
                                .cornerRadius(20)
                                .foregroundColor(.white)
                                .font(Font.body.bold())
                                .padding()
                            }   
                                .transition(
                                    AnyTransition.move(edge: .bottom).combined(with: .opacity)
                                )
                        }
                    }
                    Button(action: {
                        withAnimation(.spring()) {
                            self.showDetail.toggle()
                        }
                    }) {
                        Image(systemName: "chevron.right.circle").font(.system(size: 50))
                            .rotationEffect(.degrees(showDetail ? -90 : 0))
                            .scaleEffect(showDetail ? 1.3 : 1)
                            .foregroundColor(showDetail ? .orange : .blue)
                    }
                }
            }
          
            .navigationBarItems(leading:
                Button(action: {
                    self.showingSettings.toggle()
                }) {
                    Image(systemName: "gear")
                        .frame(width: 10, height: 10)
            }
                .sheet(isPresented: $showingSettings) {
                    SettingsView()
            })
                .navigationBarTitle("Yleisnäkymä")
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
                .padding(0)
            
            if verticalSizeClass == .regular {
                IpadWelcomeView()
            }
        }
    }
    
    func budgetRowColor() -> Color {
        return .blue
    }
    
    func remainingBalance(in budget: Budget) -> Int16 {
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
