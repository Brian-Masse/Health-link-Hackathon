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

let pillA = ContraProduct(name: "Combination Estrogen and Progestin Pill",
                          description: "This oral contraceptive contains both estrogen and progestin hormones. It prevents ovulation, thickens cervical mucus to block sperm, and thins the uterine lining. It must be taken daily around the same time.",
                          icon: "pill",
                          links: [
                            "https://www.mayoclinic.org/tests-procedures/combination-birth-control-pills/about/pac-20385282",
                            "https://order.store.mayoclinic.com/flex/mmv/preg3gd/?altkey=PRGORG"
                          ],
                          summaryBlock: .init(fullSummary: "Combination birth control pills, also known as the pill, are oral contraceptives that contain estrogen and a progestin. Oral contraceptives are medicines used to prevent pregnancy. They can have other benefits too.\n\nCombination birth control pills keep you from ovulating. This means that the pills keep your ovaries from releasing an egg. They also cause changes to the mucus in the opening of the uterus, called the cervix, and to the lining of the uterus, called the endometrium. These changes keep sperm from joining the egg.\n\nDifferent types of combination birth control pills contain different doses of estrogen and progestin. Continuous-dosing or extended-cycle pills allow you to reduce the number of periods you have each year.\n\nIf you want to use combination birth control pills, your health care provider can help you decide which type is right for you.",
                                             source: "Mayo Clinic")
)

let pillB = ContraProduct(name: "PillB", description: "Test Description")

let cep = ContraProduct(name: "CEP", description: "Test Description")


//MARK: ContraProduct
struct ContraProduct: Identifiable {
    
    struct SummaryBlock {
        let fullSummary: String
        let source: String
    }
    
    enum ContraceptionType: String {
        case pill
        case implant
        case emergency
        case shot
    }
    
    
    let name: String
    let icon: String
    let description: String
    let contraceptionType: ContraceptionType
    
    let links: [String]
    let summaryBlock: SummaryBlock?
    
    var id: String { name }
    
//    measured in s
    let frequency: Double
    
//    MARK: init
    init (name: String,
          description: String,
          icon: String = "pill",
          contraceptionType: ContraceptionType = .pill,
          links: [String] = [],
          summaryBlock: SummaryBlock? = nil,
          frequency: Double = Constants.DayTime) {
        
        self.name = name
        self.description = description
        self.icon = icon
        self.contraceptionType = contraceptionType
        
        self.links = links
        self.summaryBlock = summaryBlock
        
        self.frequency = frequency
    }
    
//    MARK: convenience functions
    func formatFrequency() -> String {
        
        let dayCount = Int( frequency / Constants.DayTime )
        
        if dayCount == 1 { return "take every day" }
        else { return "take every \(dayCount) days" }
        
    }
}
