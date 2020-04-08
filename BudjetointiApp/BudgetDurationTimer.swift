//
//  DurationTimer.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 30.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI


struct TimerView: View {
    var duration: Int16
    var startDate: Date

    @State private var currentDate = Date()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(displayTime())
            .onReceive(timer) { input in
                self.currentDate = input
                if self.timeDifference().second ?? 0 < 1 {
                    self.resetTimer()
                }
            }
    }

    func resetTimer() {
        self.timer.upstream.connect().cancel()
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
       
    }
    
    func timeDifference() -> DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        let budgetEndDate = Calendar.current.date(byAdding: .day, value: Int(duration), to: startDate)!
        let timeDifference = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: budgetEndDate)
        
        return timeDifference
    }
    func displayTime() -> String {
        let day = timeDifference().day ?? 0
        let hour = timeDifference().hour ?? 0
        let minute = timeDifference().minute ?? 0
        let second = timeDifference().second ?? 0
        
        var format = String(format: "%d pv, %d h", day, hour)

        if day < 1 {
            format =  String(format: "%d h", hour)
        }
        if hour < 1 {
            format =  String(format: "%d m", minute)
        }
        return format
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
