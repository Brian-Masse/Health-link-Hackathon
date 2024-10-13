//
//  PrivacyReport.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI
import UIUniversals

//MARK: Privacy Report
struct PrivacyReport: View {
    
//    MARK: Privacy Section
    @ViewBuilder
    private func makePrivacySection<C: View>(icon: String, title: String, message: String, content: () -> C = { EmptyView() } ) -> some View {
        
        HStack {
            Spacer()
            
            VStack {
                VStack {
                    Image(systemName: icon)
                    Text( title )
                }
                .font(.title2)
                .bold()
                
                Text(message)
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .opacity(0.75)
                
                content()
                    .padding(.top)
            }
            
            Spacer()
        }
        .rectangularBackground(style: .transparent)
        .padding(.bottom)
    }
    
    
    @ViewBuilder
    private func makeSummaryNode(icon: String, message: String) -> some View {
        HStack {
            Image(systemName: icon)
                
            
            Text( message )
                .lineLimit(2)
        }
        .font(.callout)
        .bold()
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func makeSummaryList( icon1: String, _ msg1: String,
                                  icon2: String = "", _ msg2: String = "",
                                  icon3: String, _ msg3: String,
                                  icon4: String = "", _ msg4: String = "" ) -> some View {
        
        HStack {
            VStack {
               makeSummaryNode(icon: icon1, message: msg1)
                if !icon2.isEmpty {
                    makeSummaryNode(icon: icon2, message: msg2)
                }
            }
            
            Spacer()
            
            VStack {
                makeSummaryNode(icon: icon3, message: msg3)
                if !icon4.isEmpty {
                    makeSummaryNode(icon: icon4, message: msg4)
                }
            }
        }
        
    }
    
//    MARK: Body
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Shorter Privacy Summary")
                .font(.title)
                .bold()
            
            Text( "By using Shorter, you agree to the privacy policies stated [here](https://s3.us-east-2.amazonaws.com/www.recallprivacynotice.com/ShorterPrivacyPolicy.html)." )
                .font(.callout)
                .opacity(0.5)
                .padding(.bottom)
            
            ScrollView(.vertical, showsIndicators: false) {
                makePrivacySection(icon: "macpro.gen3.server",
                                   title: "Data Collection",
                                   message: "Shorter will never sell, distribute, manipulate or falsify your data. All stored data is explicitly created by the user.") {
                    
                    makeSummaryList(icon1: "info.circle", "full name",
                                    icon3: "phone", "contact info")
                }
                
                makePrivacySection(icon: "hand.raised",
                                   title: "Safety",
                                   message: "Shorter gives user the ability to filter the content they see.")  {
                    
                    makeSummaryList(icon1: "person.slash", "block users",
                                    icon2: "exclamationmark.shield", "report posts",
                                    icon3: "figure.and.child.holdinghands", "filter mature content",
                                    icon4: "square.slash", "hide posts")
                }
                
                makePrivacySection(icon: "chart.line.uptrend.xyaxis",
                                   title: "analytics",
                                   message: "Shorter does not collect any analytic data on its users. It is privatley owned and maintained.")
                
                makePrivacySection(icon: "exclamationmark.triangle",
                                   title: "Abusive content",
                                   message: "Shorter does not tolerate any abusive content, including hate speech, pornography, or violence.")
                    .foregroundStyle(.red)
                    .padding(.bottom)
            }

            HStack { Spacer() }
            
            Spacer()

        }
    }
}

