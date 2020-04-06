//
//  ShowBudgetsView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 19.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct ShowBudgetsView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Budget.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Budget.name, ascending: true),
    ])
    
    var budgets: FetchedResults<Budget>
    
    @State private var showingAlert = false
    @State private var showingAddBudget = false
    @State private var showingEditBudget = false
    @State var offsets: IndexSet?
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    List {
                        if budgets.isEmpty {
                            Section {
                                Text("Ei yhtään budjettia")
                                    .foregroundColor(.gray)
                                    .font(.headline)
                            }
                        }
                        else {
                            Section {
                                ForEach(budgets, id: \.self) { budget in
                                    NavigationLink(destination: EditBudgetView(selectedBudget: budget).environment(\.managedObjectContext, self.moc)) {
                                        HStack {
                                            Text(budget.wrappedName)
                                                .font(.headline)
                                            
                                            Spacer()
                                            
                                            VStack(alignment: .trailing) {
                                                Text("\(Calculate().remainingBalance(in: budget)) €")
                                                    .fontWeight(.heavy)
                                            }
                                        }
                                    }
                                    .actionSheet(isPresented: self.$showingAlert) {
                                        ActionSheet(title: Text(budget.wrappedName), message: Text("Haluatko varmasti poistaa budjetin ja kaikki sen menot?"), buttons: [.destructive(Text("Poista")) {
                                            if let offsets = self.offsets {
                                                for offset in offsets {
                                                    // find this expense in our fetch request
                                                    let budget = self.budgets[offset]
                                                    
                                                    // delete it from the context
                                                    self.moc.delete(budget)
                                                }
                                                
                                                // save the context
                                                if self.moc.hasChanges {
                                                    try? self.moc.save()
                                                }
                                            }
                                        }, .cancel()])
                                    }
                                }
                                .onDelete(perform: deleteBudgets)
                            }
                        }
                    }
                }
                VStack {
                    Button(action: {
                        self.showingAddBudget.toggle()
                    }) {
                        Image(systemName: "centsign.circle")
                            .resizable()
                            .frame(width:30, height: 30)
                    }
                    .sheet(isPresented: self.$showingAddBudget) {
                        AddBudgetView().environment(\.managedObjectContext, self.moc)
                    }
                    .frame(width: 150, height: 30)
                    .padding(.all)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .font(Font.body.bold())
                    
                    Text("Uusi Budjetti")
                        .font(.footnote)
                        .padding(2)
                    
                } 
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetView().environment(\.managedObjectContext, self.moc)
            }
            .navigationBarTitle("Budjetit")
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "x.circle")
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    func deleteBudgets(at offsets: IndexSet) {
        showingAlert = true
        self.offsets = offsets
    }
}

//struct ShowBudgetsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddBudgetView()
//    }
//}
