//
//  TabBar.swift
//  Recall
//
//  Created by Brian Masse on 8/22/24.
//

import Foundation
import SwiftUI
import UIUniversals


//    MARK: Tabbar
struct TabBar: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Namespace private var tabBarNamespace
    @Binding var pageSelection: MainView.MainPage
    
    @State private var showingCreateEventScreen: Bool = false
    
    private let buttonPadding: Double = 15
//
    private let buttonRadius: Double = 42.5
    private let surroundingPadding: Double = 5
    
//    MARK: TabBarButton
    @ViewBuilder
    private func makeTabBarButton(page: MainView.MainPage, icon: String) -> some View {
        let isActivePage = page == pageSelection
        
        UniversalButton {
            ZStack {
                if page == pageSelection {
                    RoundedRectangle(cornerRadius: 100)
                        .transition(.scale.combined(with: .blurReplace()))
                        .matchedGeometryEffect(id: "highlight", in: tabBarNamespace)
                        .frame(width: buttonRadius * 2, height: buttonRadius * 2 * 2/3)
                        .universalStyledBackgrond(.accent, onForeground: true)
                }
                
                ContraIcon(icon)
                    .bold()
                    .frame(width: 20, height: 20)
                    .foregroundStyle( isActivePage ? .black : ( colorScheme == .dark ? .white : .black ) )
                    .padding(buttonPadding)
            }
            
        } action: {
            pageSelection = page
        }
    }
    
//    MARK: Body
    var body: some View {
        HStack {
//            makeRecallButton()
            
            HStack(spacing: 0) {
                makeTabBarButton(page: .home, icon: "house")
                makeTabBarButton(page: .social, icon: "message")
            }
            .padding(surroundingPadding)
            .background {
                RoundedRectangle(cornerRadius: 55)
                    .foregroundStyle(.thinMaterial)
                    .shadow(radius: 5)
            }
        }
        .frame(height: (buttonRadius * 2) + (surroundingPadding * 2) )
    }
}
