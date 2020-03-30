//
//  SettingsView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var darkMode = true
    
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: $darkMode, label: {
                    Text("Automaattinen tumma tila")
                })
            }
        .navigationBarTitle("Asetukset")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
