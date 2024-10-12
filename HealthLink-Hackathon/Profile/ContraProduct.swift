//
//  ContraProduct.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI
import UIUniversals

//MARK: Products
let IUD = ContraProduct(name: "IUD", description: "Test Description")

let pillA = ContraProduct(name: "PillA", description: "Test Description")
let pillB = ContraProduct(name: "PillB", description: "Test Description")

let cep = ContraProduct(name: "CEP", description: "Test Description")

struct ContraProduct: Identifiable {
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
