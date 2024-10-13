//
//  HomePageView.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI
import UIUniversals

//MARK: HomePageView
struct HomePageView: View {
    
    @ObservedObject var profile: ContraProfile
    
    @State private var activeProduct: ContraProduct? = nil
    
    
//    MARK: Product Reccomendation
    @ViewBuilder
    private func makeProductRecommendation(_ product: ContraProduct, description: String, activeProduct: Bool = false) -> some View {
        
        HStack {
            
            Image(systemName: product.icon)
                .font(.title)
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.title3)
                    .bold()
                
                Text(description)
                    .font(.callout)
                    .opacity(0.75)
                    .lineLimit(3)
                
            }
            Spacer()
            
            if !activeProduct {
                ContraIcon("plus")
                    .onTapGesture { withAnimation { profile.addProduct(product) }}
            }
        }
        .rectangularBackground(style: activeProduct ? .accent : .secondary)
        .onTapGesture { self.activeProduct = product }
    }
    
    @ViewBuilder
    private func makeProductRecommendations() -> some View {
        
        VStack (alignment: .leading) {
            if profile.activeProducts.count == 0 {
                Text( "Recommended Products" )
                    .bold()
                
                
                ForEach( 0..<profile.filteredRecommendedProducts.count, id: \.self ) { i in
                    
                    let rec = profile.recommendedProducts[i]
                    
                    makeProductRecommendation(rec.product, description: rec.justification)
                }
            } else {
                
                Text( "My products" )
                    .bold()
                
                ForEach( 0..<profile.activeProducts.count, id: \.self ) { i in
                    let product = profile.activeProducts[i]
                    
                    makeProductRecommendation(product, description: product.description, activeProduct: true)
                }
            }
        }
    }
    
//    MARK: Schedule
    @ViewBuilder
    private func makeScheduleReminder(_ product: ContraProduct, date: Date) -> some View {
        HStack {
            
            Image(systemName: "calendar")
                
            VStack(alignment: .leading) {
                Text("\(product.name)")
                    .bold()
                    .font(.title3)
                
                Text("\(date.formatted(date: .abbreviated, time: .omitted))")
            }
            
            Spacer()
            
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    private func makeSchedule() -> some View {
        VStack(alignment: .leading) {
            
            let formatter = Date.FormatStyle().day(.twoDigits)
            let weekDayFormatter = Date.FormatStyle().weekday(.short)
            
            Text("Schedule")
                .bold()
            
            VStack {
                HStack {
                    ForEach( 0..<7, id: \.self ) { i in
                        
                        let date = Date.now + Constants.DayTime * Double(i)
                        //
                        Spacer()
                        //
                        VStack {
                            Text( date.formatted(formatter) )
                                .font(.title)
                                .bold()
                            
                            Text( date.formatted(weekDayFormatter))
                        }
                        //
                        Spacer()
                    }
                } .padding(.bottom)
                
                
                ForEach( 0..<profile.activeProducts.count, id: \.self ) { i in
                    
                    let product = profile.activeProducts[i]
                    if let nextDate = profile.schedule.getNextEntryDate(for: product) {
                        
                        makeScheduleReminder(product, date: nextDate)
                    }
                }
                .opacity(0.75)
            }.rectangularBackground(style: .secondary)
        }
    }
    
    
//    MARK: Entry Record
    @ViewBuilder
    private func makeEntryRecor( _ entry: ContraEntryNode ) -> some View {
        HStack {
            Image(systemName: "calendar.day.timeline.left")
            
            VStack(alignment: .leading) {
                
                Text("\(entry.product.name)")
                    .bold()
                Text(entry.date.formatted(date: .numeric, time: .omitted))
                    .padding(.bottom, 7)
                
                Text(entry.notes)
                    .opacity(0.75)
            }
            
            Spacer()
        }
        .rectangularBackground(style: .secondary)
    }
    
    @ViewBuilder
    private func makeEntryRecords() -> some View {
        VStack(alignment: .leading) {
            Text("Entry Record")
                .bold()
            
            ForEach(0..<profile.schedule.entryRecord.count, id: \.self) { i in
                let entry = profile.schedule.entryRecord[i]
                
                makeEntryRecor(entry)
            }
        }
    }
    
    
//    MARK: Body
    var body: some View {
        VStack(alignment: .leading) {
            Text("hello \(profile.firstName)")
                .bold()
                .font(.title)
                .padding(.bottom, 7)
       
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    makeProductRecommendations()
                        .padding(.bottom)
                    
                    makeSchedule()
                        .padding(.bottom)
                    
                    makeEntryRecords()
                }
                .padding(.bottom, 80)
            }
            
            Spacer()
        }
        .padding()
        .sheet(item: $activeProduct) { product in ContraProductView(product: product, profile: profile) }
        .ignoresSafeArea(edges: .bottom)
    }
}


#Preview {
    
    HomePageView(profile: exampleProfile)
}


