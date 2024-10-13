//
//  ContraModel.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI

class ContraModel: ObservableObject {
    
    static let shared = ContraModel()
    
    @Published private(set) var appState = AppState.questionaire
    
    enum AppState {
        case questionaire
        case transition
        case main
    }
    
    
    func setAppState(_ state: AppState) {
        withAnimation {
            self.appState = state
        }
    }
    
}
