//
//  BudgetStatsView.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 6.4.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct BudgetStatsView: View {
    @ObservedObject var budgetDetails: Budget
    
    var durationText: String {
        var duration = ""
        
        switch budgetDetails.duration {
        case 7:
            duration = "Tämän viikon"
        case 30:
            duration = "Tämän kuukauden"
        case 365:
            duration = "Tämän vuoden"
        default:
            duration = "Tämän päivän"
        }
        
        return duration
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(durationText)
                .font(.largeTitle)
                .foregroundColor(.gray)
                .padding(10)
            VStack(alignment: .trailing) {
                HStack {
                    Image(systemName: "chevron.up")
                        .foregroundColor(.red)
                        .padding(.leading, 7)
                    Text("Menot")
                        .padding(.leading, 7)
                        .font(.headline)
                    
                    Spacer()
                    Text("\(Calculate().totalSpent(in: budgetDetails)) €")
                        .font(.largeTitle)
                        .padding(.trailing, 7)
                }
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 100)
                .background(
                    Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(15)
                        .opacity(0.2)
                )
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .trailing) {
                
                HStack {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.green)
                        .padding(.leading, 7)
                    Text("Tulot")
                        .padding(.leading, 7)
                        .font(.headline)
                    
                    Spacer()
                    Text("\(Calculate().totalReceived(in: budgetDetails)) €")
                        .font(.largeTitle)
                        .padding(.trailing, 7)
                }
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 100)
                .background(
                    Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(15)
                        .opacity(0.2)
                )
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .trailing) {
                
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(.blue)
                        .padding(.leading, 7)
                    Text("Tapahtumat yhteensä")
                        .padding(.leading, 7)
                        .font(.headline)
                    
                    Spacer()
                    Text("\(Calculate().totalEvents(in: budgetDetails)) kpl")
                        .font(.largeTitle)
                        .padding(.trailing, 7)
                }
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 100)
                .background(
                    Rectangle()
                        .foregroundColor(.gray)
                        .cornerRadius(15)
                        .opacity(0.2)
                )
            }
            
            
        }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
            .padding(10)
            .navigationBarTitle("Yhteenveto")
    }
}
