//
//  BottomMenuView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 2.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct BottomMenuView: View { 
    @Binding var showMenu: Bool
    @Binding var showBudgets: Bool
    @Binding var showTransfer: Bool
    //@Binding var showingMainPageAddExpense: Bool
    
    var body: some View {
        HStack {
            if self.showMenu {
                VStack(alignment: .leading) {
                    HStack {
                        Button(action: {
                            self.showTransfer.toggle()
                            withAnimation(.spring()) {
                               self.showMenu = false
                            }
                        }) {
                            Image(systemName: "arrow.right.arrow.left")
                                .modifier(RoundButton(color: .purple, size: (20, 20)))
                        }
                        
                        Text("Siirrä")
                            .font(.footnote)
                    }
                    HStack {
                        Button(action: {
                            self.showBudgets.toggle()
                            withAnimation(.spring()) {
                               self.showMenu = false
                            }
                            
                            
                        }) {
                            Image(systemName: "centsign.circle")
                                .modifier(RoundButton(color: .blue, size: (20, 20)))
                        }
                        
                        Text("Budjetit")
                            .font(.footnote)
                    }
                    .padding(.bottom, 6)
                }
                .transition(
                    AnyTransition.move(edge: .bottom).combined(with: .opacity)
                )

            }
            Button(action: {
                withAnimation(.spring()) {
                    self.showMenu.toggle()
                }
            }) {
                Image(systemName: "chevron.right").font(.system(size: 50))
                    .rotationEffect(.degrees(showMenu ? 0 : -90))
                    .opacity(showMenu ? 0.5 : 1)
                    .foregroundColor(showMenu ? .orange : .blue)
//                    .scaleEffect(showMenu ? 0.7 : 1)
            }
        }
    }
}
