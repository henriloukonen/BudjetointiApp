//
//  DurationTimer.swift
//  BudjetointiApp
//
//  Created by Henri Loukonen on 30.3.2020.
//  Copyright © 2020 Henri Loukonen. All rights reserved.
//

import SwiftUI

struct DurationTimer: View {
    @Binding var duration: Int16 
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DurationTimer_Previews: PreviewProvider {
    static var previews: some View {
        DurationTimer(duration: .constant(4))
    }
}
