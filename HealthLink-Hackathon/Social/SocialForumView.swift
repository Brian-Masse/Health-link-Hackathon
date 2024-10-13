//
//  SocialForumView.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI
import UIUniversals

struct SocialFormView: View {
    
//    MARK: Vars
    @State private var question: String = ""
    
    
    
//    MARK: mentor
    @ViewBuilder
    private func makeMentorInfoPoint(icon: String, text: String) -> some View {
        VStack {
            ContraIcon(icon)
                .font(.title3)
            
            Text( text )
                .font(.callout)
                .opacity(0.75)
                .lineLimit(1)
        }
        .frame(width: 100)
    }
    
    @ViewBuilder
    private func makeMentorProfile(_ profile: ContraProfile) -> some View {
        
        VStack(alignment: .leading) {
            
            Text(profile.fullName)
                .padding(.leading)
                .font(.title3)
                .bold()
            
            Text("contra users since \(profile.dateJoined.formatted(date: .abbreviated, time: .omitted))")
                .padding(.bottom)
                .padding(.leading)
            
            HStack {
                Spacer()
                makeMentorInfoPoint(icon: "birthday.cake", text: "\(profile.age) yrs")
                Spacer()
                makeMentorInfoPoint(icon: "map", text: profile.state)
                Spacer()
                makeMentorInfoPoint(icon: "flag", text: profile.ethnicity.first!)
                Spacer()
            }
        }
        .frame(width: 300)
        .rectangularBackground(style: .secondary)
    }
    
//    MARK: makeMentorsPage
    @ViewBuilder
    private func makeMentorsPage() -> some View {
        VStack(alignment: .leading) {
            Text("Connect with Mentors")
                .font(.title2)
                .bold()
            
            Text("Contra mentors are real people who have found and used contraception products")
                .font(.callout)
                .opacity(0.75)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    makeMentorProfile(exampleProfile1)
                    
                    makeMentorProfile(exampleProfile2)
                    
                    makeMentorProfile(exampleProfile3)
                }
            }
            
            HStack {
                Spacer()
                
                Text("become a mentor")
                    .bold()
                    .font(.title3)
                
                ContraIcon("arrow.uturn.right")
                
                Spacer()
            }
            .rectangularBackground(style: .accent)
            .padding(.bottom)
            
            HStack(alignment: .bottom) {
                StyledTextField(title: "Ask a question to other contra members", binding: $question)
                
                ContraIcon("icloud.and.arrow.up")
                    .rectangularBackground(style: .secondary)
            }
            Text("this question is completley anonymous and does not share any of your personal information")
                .font(.caption)
                .padding(.horizontal)
        }
        
    }
    
//    MARK: Body
    var body: some View {
        makeMentorsPage()
    }
}



#Preview {
    SocialFormView()
}
