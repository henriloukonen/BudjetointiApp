//
//  DurationTimer.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 30.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct DurationTimer: View {
    var duration: Int16
    var startDate: Date
    
    @State var currentDate = Date()

    
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.currentDate = Date()
        }
    }
    
    
    var body: some View {
        Text("\(TimeCountdown(using: duration))")
            .onAppear(perform: {self.timer})
    }
    
    func TimeCountdown(using budgetDuration: Int16) -> String {
        let budgetEndDate = Calendar.current.date(byAdding: .day, value: Int(budgetDuration), to: startDate)!
        let calendar = Calendar(identifier: .gregorian)
        let timeValue = calendar
            .dateComponents([.day], from: currentDate, to: budgetEndDate)
        
  
        return String(format: "%2d pv", timeValue.day!)
    }
}

struct DurationTimer_Previews: PreviewProvider {
    static var previews: some View {
        DurationTimer(duration: 4, startDate: Date())
    }
}
