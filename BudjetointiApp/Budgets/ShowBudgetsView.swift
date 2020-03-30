//
//  ShowBudgetsView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 19.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct ShowBudgetsView: View {
    @State private var showingAlert = false
    @State private var showingAddBudget = false
    @State private var showingEditBudget = false
    @State var offsets: IndexSet?
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    var budgets: FetchedResults<Budget>
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    List {
                        Section {
                                Button(action: {
                                    self.showingAddBudget.toggle()
                                }, label: {
                                    Text("Uusi budjetti")
                                })
                                    .font(.headline)
                        }
                        
                        
                        Section {
                            ForEach(budgets, id: \.self) { budget in
                                HStack {
                                    Text(budget.wrappedName)
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text("\(budget.budgetAmount) €")
                                            .fontWeight(.heavy)
                                    }
                                }
                                .sheet(isPresented: self.$showingEditBudget) {
                                    EditBudgetView(selectedBudget: budget).environment(\.managedObjectContext, self.moc)
                                }
                                .contextMenu {
                                    Button(action: {
                                        self.showingEditBudget.toggle()
                                    }) {
                                        Text("Muokkaa")
                                        Image(systemName: "pencil")
                                    }
                                    
                                    Button(action: {
                                        self.showingAlert = true
                                    }) {
                                        Text("Poista")
                                        Image(systemName: "trash.circle")
                                    }
                                }
                            }
                            .onDelete(perform: deleteBudgets)
                            
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetView().environment(\.managedObjectContext, self.moc)
            }
            
            .actionSheet(isPresented: $showingAlert) {
                ActionSheet(title: Text("Budjetin poisto"), message: Text("Haluatko varmasti poistaa budjetin ja kaikki sen menot?"), buttons: [.destructive(Text("Poista")) {
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
            
            .navigationBarTitle("Budjetit")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
               }, label: {
                   Text("Sulje")
               }))
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
