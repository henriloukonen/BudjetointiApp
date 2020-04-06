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
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()


    var body: some View {
        Text("\(calculateTimeDifference(using: startDate, and: duration))")
            .onReceive(timer) { _ in
                self.currentDate = Date()
            }
    }

    func cancelTimer() {
        self.timer.upstream.connect().cancel()

    }


    func calculateTimeDifference(using budgetStartDate: Date, and budgetDuration: Int16) -> String {
        let budgetEndDate = Calendar.current.date(byAdding: .day, value: Int(budgetDuration), to: budgetStartDate)!
        let calendar = Calendar(identifier: .gregorian)
        let timeValue = calendar.dateComponents([.day, .second], from: currentDate, to: budgetEndDate)

   
        return String(format: "%2d", timeValue.day!)
    }
}

//struct DurationTimer: View {
//    var duration: Int16
//    var startDate: Date
//
//    @State var currentDate = Date()
//    @State private var timeRemaining = 0.0
//
//    //    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
//
//
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//
//    var body: some View {
//
//
//        Text("\(timeRemaining)")
//            .onAppear {
//                self.timeRemaining = self.calculateTimeDifference(using: self.startDate, and: self.duration)
//        }
//        .onReceive(timer) { _ in
//            if self.timeRemaining > 1 {
//                self.timeRemaining -= 1
//            }
//        }
//    }
//
//    func calculateTimeDifference(using budgetStartDate: Date, and duration: Int16) -> Double {
//        let futureDate = Calendar.current.date(byAdding: .second, value: Int(duration), to: budgetStartDate)!
//        let difference = futureDate.timeIntervalSince(currentDate)
//
//        return difference
//    }
//}
