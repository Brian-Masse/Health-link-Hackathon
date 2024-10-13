//
//  ContentView.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import SwiftUI
import UIUniversals

//MARK: MainView
struct MainView: View {
    
//    These are the pages in the main part of the app
    enum MainPage: Int, Identifiable {
        case home
        case social
        
        var id: Int {
            self.rawValue
        }
    }
    
    
    //    MARK: Vars
    @Environment(\.colorScheme) var colorScheme
    
    @State var currentPage: MainPage = .home
    @State var uiTabarController: UITabBarController?
    
    //    MARK: Body
    
    var body: some View {

        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                TabView(selection: $currentPage) {
                
                    
                    
                    HomePageView(profile: exampleProfile)
                        .tag( MainPage.home )
                    
                    SocialPageView()
                        .tag( MainPage.social )
                }
                .animation(.easeInOut, value: currentPage)
                
                TabBar(pageSelection: $currentPage)
                    .padding(.bottom, 30)
            
            }
        }
    }
}


#Preview {
    MainView()
}
