//
//  BudgetRowBackground.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 5.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct BudgetRowBackground: View {
    let budget: Budget
    let colors: [Color] = [.red, .green, .blue, .pink, .orange, .purple, .yellow]
    let max = 100.0
    
    var body: some View {
        withAnimation(.easeIn(duration: 1.5)) {
            LinearGradient(gradient: Gradient(colors: gradientColors()), startPoint: .top, endPoint: .bottom)
        }
    }
    
    func gradientColors() -> [Color] {
        let currentBalance = Calculate().remainingBalance(in: budget)
        let spentAmount = Calculate().totalSpent(in: budget)
        var colorGradient: [Color] = []
        
        switch spentAmount {
        case _ where spentAmount < currentBalance / 2:
            colorGradient = [.green, .green]
        case _ where spentAmount == currentBalance / 2:
            colorGradient = [.orange, .orange]
        case _ where spentAmount > currentBalance / 2:
            colorGradient = [.red, .red]
//        case _ where spentAmount > currentBalance / 3:
//            colorGradient = [.pink, .pink]
//        case _ where spentAmount > currentBalance:
//            colorGradient = [.red, .red]
        default:
            colorGradient = [.black, .black]
        }
        
        return colorGradient
    }
}
