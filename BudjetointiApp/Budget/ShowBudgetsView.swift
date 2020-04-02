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
                        Section {
                            ForEach(budgets, id: \.self) { budget in
                                NavigationLink(destination: EditBudgetView(selectedBudget: budget).environment(\.managedObjectContext, self.moc)) {
                                    HStack {
                                        Text(budget.wrappedName)
                                            .font(.headline)
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing) {
                                            Text("\(budget.budgetAmount) €")
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
                VStack {
                    Button("Uusi budjetti") {
                        self.showingAddBudget.toggle()
                    } .frame(minWidth: 0, maxWidth: 130, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(11)
                    .foregroundColor(.white)
                    .font(Font.body.bold())
                   
                    } .padding()
            }
            .sheet(isPresented: $showingAddBudget) {
                AddBudgetView().environment(\.managedObjectContext, self.moc)
            }
            .navigationBarTitle("Budjetit")
            .navigationBarItems(leading: Button("Sulje") {
                self.presentationMode.wrappedValue.dismiss()
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
