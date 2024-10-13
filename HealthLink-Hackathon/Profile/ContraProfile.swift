//
//  ContraProfile.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI
import UIUniversals

let schedule = ContraUserSchedule(entryRecord: [
    .init(date: .now, product: Yaz, notes: "Still feeling really good on day 2. I'm so glad I found a personalized solution that understand my personal context"),
    .init(date: .now - Constants.DayTime, product: Yaz, notes: "First time taking birth control. Excited for a good experience!")
])

func makeBirthday() -> Date {
    var comps = DateComponents()
    comps.day = 18
    comps.month = 5
    comps.year = 2004
    
    return Calendar.current.date(from: comps)!
    
}

let exampleProfile = ContraProfile(schedule: schedule,
                                   firstName: "Anitha",
                                   lastName: "Darcy",
                                   birthday: makeBirthday(),
                                   height: 60,
                                   ethnicity: ["white"],
                                   state: "Massachusetts",
                                   firstTimeUser: true)

//MARK: ContraProfile
class ContraProfile: ObservableObject {
    
    let ownerId: String = ""
    
    let firstName: String
    let lastName: String
    var fullName: String { "\(firstName) \(lastName)" }
    
//    demographics
    let birthday: Date
    let height: Double
    let ethnicity: [String]
    let state: String
    let firstTimeUser: Bool
    
    
    let schedule: ContraUserSchedule
    
//    IUD, pillA, pillB, cep
    let recommendedProducts: [ContraRecommendation] = [
        .init(product: pillA, justification: "This oral contraceptive contains both estrogen and progestin hormones. It prevents ovulation, thickens cervical mucus to block sperm, and thins the uterine lining."),
        .init(product: Yaz, justification: "contains 4th gen progestin"),
        .init(product: implant, justification: "doesn’t affect mood, highly effective"),
    ]
    @Published var activeProducts: [ContraProduct] = []
//    [pillA, pillB]
    
//    MARK: Convenience
    var filteredRecommendedProducts: [ContraRecommendation] {
        recommendedProducts.filter { rec in
            !activeProducts.contains { activeProduct in activeProduct.name == rec.product.name }
        }
    }
    
    func isUsingProduct(_ product: ContraProduct) -> Bool {
        activeProducts.contains { activeProduct in activeProduct.name == product.name }
    }
    
    func isRecommendedProduct(_ product: ContraProduct) -> Bool {
        recommendedProducts.contains { rec in rec.product.name == product.name }
    }
    
    func getRecommendation( for product: ContraProduct ) -> ContraRecommendation? {
        recommendedProducts.first { rec in rec.product.name == product.name }
    }
    
//    MARK: Init
    init( schedule: ContraUserSchedule,
          firstName: String,
          lastName: String,
          birthday: Date,
          height: Double,
          ethnicity: [String],
          state: String,
          firstTimeUser: Bool) {
        
        self.schedule = schedule
        
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.height = height
        self.ethnicity = ethnicity
        self.state = state
        self.firstTimeUser = firstTimeUser
    }
    
    func addProduct( _ product: ContraProduct ) {
        self.activeProducts.append( product )
    }
}



//MARK: ContraUserSchedule
class ContraUserSchedule {
    let ownerId: String = ""
    
    let entryRecord: [ ContraEntryNode ]
    
    init( entryRecord: [ContraEntryNode] ) {
        self.entryRecord = entryRecord
    }
    
    func getNextEntryDate(for product: ContraProduct) -> Date? {
        if let lastDate = entryRecord.filter({ node in node.product.name == product.name }).first?.date {
            return lastDate + product.frequency
        }
        
        return nil
    }
}

//MARK: ContraEntryNode
struct ContraEntryNode {
    let date: Date
    let product: ContraProduct
    let notes: String
    
    init( date: Date = .now, product: ContraProduct, notes: String = "" ) {
        self.date = date
        self.product = product
        self.notes = notes
    }
}

//MARK: ContraRecommendation
struct ContraRecommendation {
    let recommendationDate: Date = .now
    let product: ContraProduct
    let justification: String
}
