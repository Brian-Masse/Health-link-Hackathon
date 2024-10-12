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
    .init(date: .now, product: pillA, notes: "took pills"),
    .init(date: .now - Constants.DayTime, product: pillB, notes: "")
])

func makeBirthday() -> Date {
    var comps = DateComponents()
    comps.day = 18
    comps.month = 5
    comps.year = 2005
    
    return Calendar.current.date(from: comps)!
    
}

let exampleProfile = ContraProfile(schedule: schedule,
                                   firstName: "Brian",
                                   lastName: "Masse",
                                   birthday: makeBirthday(),
                                   height: 70,
                                   ethnicity: ["white"],
                                   state: "Massachusetts",
                                   firstTimeUser: true)

//MARK: ContraProfile
class ContraProfile {
    
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
    
    let recommendedProducts: [ContraProduct] = [IUD, pillA, pillB, cep]
    let activeProducts: [ContraProduct] = [pillA, pillB]
    
    var filteredRecommendedProducts: [ContraProduct] {
        recommendedProducts.filter { product in
            !activeProducts.contains { activeProduct in activeProduct.name == product.name }
        }
    }
    
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
}


//MARK: ContraUserSchedule
class ContraUserSchedule {
    let ownerId: String = ""
    
    let entryRecord: [ ContraEntryNode ]
    
    init( entryRecord: [ContraEntryNode] ) {
        self.entryRecord = entryRecord
    }
    
    func getNextEntryDate(for product: ContraProduct) -> Date? {
        if let lastDate = entryRecord.filter({ node in node.product.name == product.name }).last?.date {
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
