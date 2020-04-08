//
//  RemainingBalanceColorIndicator.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 5.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct balanceColor: View {
    @ObservedObject var budget: Budget
    
    var body: some View {
        withAnimation(.interpolatingSpring(mass: 1, stiffness: 0.2, damping: 0.5, initialVelocity: 1)) {
            Rectangle()
                .padding(16)
                .padding(.horizontal, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(backgroundColor(), lineWidth: 4)
            )
                .opacity(0.6)
        }
    }
    
    func backgroundColor() -> Color {
        let currentBalance = Int(Calculate().remainingBalance(in: budget))
        let spentAmount = Calculate().totalSpent(in: budget)
        var color: Color
        
        switch spentAmount {
        case _ where spentAmount > currentBalance / 2:
            color = .orange
//        case _ where currentBalance <= 0:
//            color = .red
        default:
            color = .green
        }
        
        return color
    }
}
