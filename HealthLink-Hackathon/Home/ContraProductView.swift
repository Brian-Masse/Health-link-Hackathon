//
//  ContraProductView.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI
import UIUniversals

struct ContraProductView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let product: ContraProduct
    let profile: ContraProfile
    
//    MARK: Header
    @ViewBuilder
    private func makeHeader() -> some View {
        HStack(alignment: .top) {
            ContraIcon(product.icon)
                .font(.title)
                .padding(.vertical)
            
            VStack(alignment: .leading) {
                Text( product.name )
                    .bold()
                    .font(.title)
                
                Text( product.description)
                    .font(.caption)
                    .opacity(0.75)
                    .padding(.trailing, 40)
            }
        }
    }
    
//    MARK: Overview
    @ViewBuilder
    private func makeUsageBanner() -> some View {
        let isUsing = profile.isUsingProduct(product)
        let isRecomennded = profile.isRecommendedProduct(product)
        
        if isUsing || isRecomennded {
                
            let title = isUsing ? "You are currently using this product" : "we recommend this product"
                
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title3)
                        .bold()
                    
                    if !isUsing {
                        if let rec = profile.getRecommendation(for: product) {
                            Text(rec.justification)
                                .opacity(0.75)
                                .font(.callout)
                        }
                    }
                }
                
                Spacer()
                
                ContraIcon("pencil")
            }
            .rectangularBackground(style: .accent)
        }
    }
    
    @ViewBuilder
    private func makeOverviewNode(icon: String, data: String) -> some View {
        VStack {
            ContraIcon(icon)
                .font(.title2)
            
            Text(data)
                .font(.callout)
        }
        .frame(width: 150)
    }
    
    @ViewBuilder
    private func makeOverview() -> some View {
        
        Text("At a glance")
            .font(.title2)
            .bold()
        
        HStack {
            Spacer()
            
            makeOverviewNode(icon: "clock.arrow.trianglehead.counterclockwise.rotate.90", data: product.formatFrequency())
            
            Spacer()
            
            makeOverviewNode(icon: product.icon, data: product.contraceptionType.rawValue )
            
            Spacer()
        }
        .rectangularBackground(style: .secondary)
    
        makeUsageBanner()
        
    }
    
//    MARK: Summary
    @ViewBuilder
    private func makeSummary() -> some View {
        Text("Summary")
            .font(.title2)
            .bold()
        
        Text(product.summaryBlock?.source ?? "")
            .font(.caption)
        
        Text(product.summaryBlock?.fullSummary ?? "")
            .opacity(0.75)
            .font(.callout)
            .padding(.trailing)
            .padding(.bottom)
        
        Text("Read More")
            .font(.title2)
            .bold()
        
        ForEach( 0..<product.links.count, id: \.self ) { i in
            let url = URL(string: product.links[i])!
            
            Link(product.links[i], destination: url)
                .lineLimit(1)
        }
    }
    
//    MARK: Body
    var body: some View {
        VStack(alignment: .leading) {
            
            makeHeader()
                .padding(.bottom)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    makeOverview()
                    
                    makeSummary()
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.UIDefaultCornerRadius))
        }
        .padding(7)
        .background(colorScheme == .light ? .white : .black)
    }
}


#Preview {
    ContraProductView(product: pillA, profile: exampleProfile)
}
