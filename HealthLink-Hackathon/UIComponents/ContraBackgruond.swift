//
//  ContraBackgruond.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI
import UIUniversals

struct ContraBackgruond: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        
        ZStack {
            LinearGradient(colors: [ Colors.getAccent(from: colorScheme), Colors.getBase(from: colorScheme)],
                           startPoint: (colorScheme == .light ? .bottom : .top),
                           endPoint: (colorScheme == .light ? .top : .bottom))
            .opacity(0.5)
            .ignoresSafeArea()
            
            content
        }
    }
}

extension View {
    
    func contraBackgorund() -> some View {
        modifier(ContraBackgruond())
    }
}

#Preview {
    
    Text("hi")
        .modifier(ContraBackgruond())
    
}
