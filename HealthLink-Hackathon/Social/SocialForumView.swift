//
//  SocialForumView.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI

struct SocialFormView: View {
    
//    MARK: makeMentorsPage
    @ViewBuilder
    private func makeMentorsPage() -> some View {
        VStack(alignment: .leading) {
            Text("Contra Mentors")
                .bold()
            
            Text("Contra mentors are real people who have found and used contraception products")
            
            
            
            
            
        }
        
    }
    
//    MARK: Body
    var body: some View {
        Text("Social Forming View")
        
        makeMentorsPage()
    }
}



#Preview {
    SocialFormView()
}
