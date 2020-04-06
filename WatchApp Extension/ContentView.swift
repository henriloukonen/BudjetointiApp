//
//  ContentView.swift
//  WatchApp Extension
//
//  Created by Henri Loukonen on 27.2.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    
    var body: some View {
        SubView().environment(\.managedObjectContext, managedObjectContext)
    }
}

struct SubView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Budget.entity(), sortDescriptors: [
    ])
    
    var budgets: FetchedResults<Budget>
    
    var body: some View {
        List {
            ForEach(budgets, id: \.self) { budget in
                NavigationLink(destination: BudgetDetailView(budget: budget).environment(\.managedObjectContext, self.moc)) {
                    HStack {
                        Text(budget.wrappedName)
                    }
                }
            }
        }
    .navigationBarTitle("joku")
    }
}
