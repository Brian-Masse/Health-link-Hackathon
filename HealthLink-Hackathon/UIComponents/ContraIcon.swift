//
//  ContraIcon.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI

struct ContraIcon: View {
    
    let icon: String
    let bold: Bool
    
    init( _ icon: String, bold: Bool = true ) {
        self.icon = icon
        self.bold = bold
    }
    
    var body: some View {
        Image(systemName: icon)
            .bold(bold)
    }
    
}
