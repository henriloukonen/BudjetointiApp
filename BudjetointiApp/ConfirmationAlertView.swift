//
//  ConfirmationAlertView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 3.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct ConfirmationAlertView: View {
    
    @State var timeRemaining = 2
    @Binding var showConfirmation: Bool
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .center) {
            
            Image(systemName: "checkmark")
                .resizable()
                .frame(width: 70,  height: 70)
            
        }
        .transition(
            AnyTransition.move(edge: .bottom).combined(with: .opacity)
        )
        .foregroundColor(.blue)
        .scaleEffect(showConfirmation ? 1.4 : 0)
        .padding(.horizontal, 4)
        .onReceive(timer) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
            else {
                withAnimation(.spring()) {
                    self.timer.upstream.connect().cancel()
                    self.showConfirmation = false
                    self.timeRemaining = 4
                }
            }
        }
    }
}
