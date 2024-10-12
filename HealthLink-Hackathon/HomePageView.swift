//
//  HomePageView.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI
import UIUniversals

//MARK: Products
let IUD = BirthControlProduct(name: "IUD", description: "Test Description")

let pillA = BirthControlProduct(name: "PillA", description: "Test Description")
let pillB = BirthControlProduct(name: "PillB", description: "Test Description")

let cep = BirthControlProduct(name: "CEP", description: "Test Description")

struct BirthControlProduct: Identifiable {
    let name: String
    let description: String
    
    var id: String { name }
    
//    measured in s
    let frequency: Double
    
    init (name: String, description: String = "Test Description", frequency: Double = Constants.DayTime) {
        self.name = name
        self.description = description
        self.frequency = frequency
    }
}


//MARK: ContraProfile
class ContraProfile {
    
    let ownerId: String = ""
    
    let firstName: String = "Brian"
    let lastName: String = "Masse"
    
    let schedule: ContraUserSchedule
    
    let recommendedProducts: [BirthControlProduct] = [IUD, pillA, pillB, cep]
    let activeProducts: [BirthControlProduct] = [pillA, pillB]
    
    var filteredRecommendedProducts: [BirthControlProduct] {
        recommendedProducts.filter { product in
            !activeProducts.contains { activeProduct in activeProduct.name == product.name }
        }
    }
    
    init( schedule: ContraUserSchedule ) {
        self.schedule = schedule
    }
}


//MARK: ContraUserSchedule
class ContraUserSchedule {
    let ownerId: String = ""
    
    let entryRecord: [ ContraEntryNode ]
    
    init( entryRecord: [ContraEntryNode] ) {
        self.entryRecord = entryRecord
    }
    
    func getNextEntryDate(for product: BirthControlProduct) -> Date? {
        if let lastDate = entryRecord.filter({ node in node.product.name == product.name }).last?.date {
            return lastDate + product.frequency
        }
        
        return nil
    }
}

//MARK: ContraEntryNode
struct ContraEntryNode {
    let date: Date
    let product: BirthControlProduct
    let notes: String
    
    init( date: Date = .now, product: BirthControlProduct, notes: String = "" ) {
        self.date = date
        self.product = product
        self.notes = notes
    }
}

//MARK: HomePageView
struct HomePageView: View {
    
    let profile: ContraProfile
    
    
//    MARK: Product Reccomendation
    @ViewBuilder
    private func makeProductRecommendation(_ product: BirthControlProduct, activeProduct: Bool = false) -> some View {
        
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
    private func makeScheduleReminder(_ product: BirthControlProduct, date: Date) -> some View {
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
    
    let schedule = ContraUserSchedule(entryRecord: [
        .init(date: .now, product: pillA, notes: "took pills"),
        .init(date: .now - Constants.DayTime, product: pillB, notes: "")
    ])
    
    let profile = ContraProfile(schedule: schedule)
    
    HomePageView(profile: profile)
}


