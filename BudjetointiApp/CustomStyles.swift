//
//  CustomStyles.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 1.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct CustomButton: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            
            .frame(minWidth: 0, maxWidth: 100, minHeight: 0, maxHeight: 30)
            .background(Color.green)
            .cornerRadius(11)
            .foregroundColor(.white)
            .font(Font.body.bold())
            .scaleEffect(configuration.isPressed ? 0.7 : 1.0)
            
//
//            .padding()
//            .foregroundColor(.white)
//            .background(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .leading, endPoint: .trailing))
            //.cornerRadius(40)
            //.padding(.horizontal, 20)
    }
}
