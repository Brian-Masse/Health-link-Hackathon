//
//  HealthLink_HackathonApp.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import SwiftUI
import UIUniversals

@main
struct HealthLink_HackathonApp: App {
    
    private func setupUIUniversals() {
        Colors.setColors(baseLight:         .init(255, 255, 255),
                         secondaryLight:    .init(240, 240, 238),
                         baseDark:          .init(0, 0, 0),
                         secondaryDark:     .init(27.5, 27.5, 25.5),
                         lightAccent:       .init(65, 82, 79),
                         darkAccent:        .init(148, 166, 151),
                         matchDefaults: true)
        
        Constants.UIDefaultCornerRadius = 20
        
        Constants.setFontSizes(UILargeTextSize: 90,
                               UITitleTextSize: 45,
                               UIMainHeaderTextSize: 35,
                               UIHeaderTextSize: 30,
                               UISubHeaderTextSize: 20,
                               UIDefeaultTextSize: 15,
                               UISmallTextSize: 11)
        
//        This registers all the fonts provided by UIUniversals
        FontProvider.registerFonts()
//        Constants.titleFont = FontProvider[.syneHeavy]
//        Constants.mainFont = FontProvider[.renoMono]
        
        UITabBar.appearance().isHidden = true
    }
    
//    before anything is done in the app, make sure UIUniversals is properly initialized
    init() { setupUIUniversals() }
    
    var body: some Scene {
        WindowGroup {
            ContraView()
        }
    }
}
