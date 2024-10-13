//
//  ContraIcon.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI
import UIUniversals

struct ContraIcon: View {
    
    let icon: String
    let bold: Bool
    
    let action: (() -> Void)?
    
    init( _ icon: String, bold: Bool = true, action: (() -> Void)? = nil) {
        self.icon = icon
        self.bold = bold
        self.action = action
    }
    
    var body: some View {
        if let action {
            UniversalButton {
                Image(systemName: icon)
                    .bold(bold)
                
            } action: { action() }
        } else {
            Image(systemName: icon)
                .bold(bold)
        }
    }
}
