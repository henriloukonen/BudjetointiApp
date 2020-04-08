//
//  SettingsView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 21.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var darkMode = UserDefaults.standard.bool(forKey: "darkMode")
    @State private var secureApp = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Yleiset")) {
                    Toggle(isOn: $darkMode, label: {
                        Text("Älä käytä automaattista tummaa tilaa")
                    })
                        .onDisappear {
                            UserDefaults.standard.set(self.darkMode, forKey: "darkMode")
                    }
                    
                }
                
                Section(header: Text("Turvallisuus")) {
                    Toggle(isOn: $secureApp, label: {
                        Text("Käytä Touch ID/Face ID suojausta")
                        }) .disabled(true)
                }
            }
            .navigationBarTitle("Asetukset")
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "x.circle")
                
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
