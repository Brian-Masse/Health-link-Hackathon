//
//  ContraView.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI

struct ContraView: View {
    
    @ObservedObject private var viewModel: ContraModel = ContraModel.shared
    
    @ViewBuilder private func makeTransitionView() -> some View {
        
        ContraSplashScreen("Finding the right solution for you...", highlighting: "for you")
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { viewModel.setAppState(.main) }
            }
    }
    
    
    var body: some View {
        
        VStack {
            switch viewModel.appState {
            case .questionaire: ContraQuestionaire()
            case .transition: makeTransitionView()
            case .main: MainView()
            }
        }
    }
}
