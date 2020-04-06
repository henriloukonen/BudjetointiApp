//
//  IpadWelcomeView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 28.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct IpadWelcomeView: View {
    
    var body: some View {
        VStack {
            Text("Valitse budjetti vasemmasta reunasta")
                .foregroundColor(.secondary)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        IpadWelcomeView()
    }
}
