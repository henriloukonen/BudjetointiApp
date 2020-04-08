//
//  CustomModifiers.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 7.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI
import Combine

struct CheckForNumbers: ViewModifier {
    @State var textField = ""
    
    func body(content: Content) -> some View {
        content
            .onReceive(Just(textField)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    self.textField = filtered
                }
            }
    }
}

struct RoundButton: ViewModifier {
    let color: Color
    let size: (width: CGFloat, height: CGFloat)
    
    func body(content: Content) -> some View {
        content
            .frame(width: size.width, height: size.height)
            .padding(.all)
            .background(color)
            .clipShape(Circle())
            .foregroundColor(.white)
            .font(Font.body.bold())
    }
}
