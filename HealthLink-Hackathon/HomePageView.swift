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
    
    let profile: ContraProfile
    
    
//    MARK: Product Reccomendation
    @ViewBuilder
    private func makeProductRecommendation(_ product: ContraProduct, activeProduct: Bool = false) -> some View {
        
        HStack {
            
            Image(systemName: "pills.circle")
                .font(.title)
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.title3)
                    .bold()
                
                Text(product.description)
                
            }
            Spacer()
        }
        .rectangularBackground(style: activeProduct ? .accent : .secondary)
    }
    
    @ViewBuilder
    private func makeProductRecommendations() -> some View {
        
        VStack (alignment: .leading) {
            
            Text( "My products" )
                .bold()
            
            ForEach( 0..<profile.activeProducts.count, id: \.self ) { i in
                let product = profile.recommendedProducts[i]
                
                makeProductRecommendation(product, activeProduct: true)
            }
            
            Text( "Recommended Products" )
                .bold()
            
            ForEach( 0..<profile.filteredRecommendedProducts.count, id: \.self ) { i in
                
                let product = profile.recommendedProducts[i]
                
                makeProductRecommendation(product)
                
            }
        }
    }
    
//    MARK: Schedule
    @ViewBuilder
    private func makeScheduleReminder(_ product: ContraProduct, date: Date) -> some View {
        HStack {
            
            Image(systemName: "calendar")
                
            Text("\(product.name)")
                .bold()
                .font(.title3)
            
            Spacer()
            
            Text("\(date.formatted(date: .abbreviated, time: .omitted))")
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
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "calendar.day.timeline.left")
                
                Text("\(entry.product.name)")
                
                Spacer()
            }
            
            Text(entry.date.formatted(date: .numeric, time: .omitted))
            
            Text(entry.notes)
                .opacity(0.75)
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
       
            ScrollView(.vertical) {
                makeProductRecommendations()
                    .padding(.bottom)
                
                makeSchedule()
                
                makeEntryRecords()
            }
            
            Spacer()
        }
        .padding()
    }
}


#Preview {
    
    HomePageView(profile: exampleProfile)
}


