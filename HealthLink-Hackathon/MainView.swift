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

        let schedule = ContraUserSchedule(entryRecord: [
            .init(date: .now, product: pillA, notes: "took pills"),
            .init(date: .now - Constants.DayTime, product: pillB, notes: "")
        ])
        
        let profile = ContraProfile(schedule: schedule)
        
        
        
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                TabView(selection: $currentPage) {
                
                    HomePageView(profile: profile)
                        .tag( MainPage.home )
                    
                    SocialPageView()
                        .tag( MainPage.social )
                }
                .animation(.easeInOut, value: currentPage)
                
                TabBar(pageSelection: $currentPage)
                    .padding(.bottom, 30)
                
            }
        }
        .universalBackground()
    }
}


#Preview {
    MainView()
}
