//
//  ContraQuestionaire.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI
import UIUniversals

struct ContraQuestionaire: View {

//    MARK: subnit
    private func submit() {
        
        ContraModel.shared.setAppState(.transition)
    }
    
//    MARK: Scene
    private enum QuestionaireScene: Int, ContraSceneEnum {
        func getTitle() -> String {
            switch self {
            case .splash: return "he"
            case .overview: return "Overview"
            case .demographics: return "Demographics"
            case .medical: return "Medical"
            case .lifestyle: return "Lifestyle"
            }
        }
        
        case splash
        case overview
        case demographics
        case medical
        case lifestyle
        
        var id: Int { self.rawValue }
    }
    
    static let ethnicityOptions = [
        "White",
        "Hispanic",
        "Black",
        "Asian",
        "Native American",
        "Pacific Islander"
    ]
    
    static let preExistingConditionOptions = [
        "Pre-existing cardiovascular condition",
        "Type-1 diabetes",
        "Hypertension",
        "Predisposition to stroke or myocardial infarction",
        "Angioedema",
        "None of the above"
    ]
    
    static let contraceptionReasoning = [
        "Pregnancy prevention",
        "Acne",
        "Irregular period",
        "Heavy period"

    ]
    
    static let frequencyOptions: [String] = [
        "Daily",
        "less Frequent",
        "No Preference"
    ]
    
    static let birthControlOptions: [String] = [
        "The pill",
        "IUD",
        "Skin patch",
        "Vaginal ring",
        "Injectables",
        "Arm implant"
    ]
    
    
//    MARK: Vars
    @State private var splashText: String = "Welcome to ContraCare."
    @State private var splashHighlight: String = "ContraCare"
    
    @State private var activeScene: QuestionaireScene = .splash
    @State private var sceneComplete: Bool = false
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var birthday: Date = .now
    
    @State private var height: Double = 0
    @State private var ethnicity: [String] = []
    @State private var state: String = ""
    
    @State private var firstTimeUser: Bool = false
    @State private var preExistingConditions: [String] = []
    
    @State private var acneProne: Bool = false
    @State private var antiseizure: Bool = false
    @State private var smoker: Bool = false
    @State private var moodSwings: Bool = false
    @State private var PMSSymtoms: Bool = false
    @State private var historOfMentalIllness: Bool = false
    @State private var irregylarPeriods: Bool = false
    @State private var contraception: [String] = []
    
    @State private var struggleWithSchedule: Bool = false
    @State private var frequencyPreference: [String] = []
    @State private var avoidedBirthControlMethods: [String] = []
    
//    MARK: makeSplashScreen
    @ViewBuilder
    private func makeSplashScreen() -> some View {
        ContraSplashScreen(splashText, highlighting: splashHighlight)
            .onAppear {
                sceneComplete = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        splashText = "Find the right care for you."
                        splashHighlight = "for you"
                    }
                }
                
            }
    }
    
//    MARK: makeOverviewScene
    private func checkOverviewCompletion() {
        let validBirthday = true
        
//        abs(birthday.timeIntervalSince(.now)) > 16 * Constants.DayTime * 365
        
        self.sceneComplete = !firstName.isEmpty && !lastName.isEmpty && validBirthday
    }
    
    @ViewBuilder
    private func makeOverviewScene() -> some View {
        VStack(alignment: .leading) {
            
            StyledTextField(title: "Name", binding: $firstName, prompt: "First Name")
            
            StyledTextField(title: "", binding: $lastName, prompt: "Last Name")
                .padding(.bottom)
            
            StyledDatePicker($birthday, title: "Birthday")
        }
        .onChange(of: firstName) { checkOverviewCompletion() }
        .onChange(of: lastName) { checkOverviewCompletion() }
        .onChange(of: birthday) { checkOverviewCompletion() }
    }
    
//    MARK: makeDemographics
    private func checkDemographicsCompletion() {
        self.sceneComplete = !height.isZero && !state.isEmpty && !ethnicity.isEmpty
    }
    
    @ViewBuilder
    private func makeDemographicsScene() -> some View {
        let heightBinding = Binding<String>(get: { String(height) }, set: { height = Double($0) ?? 0 })
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                
                StyledTextField(title: "height (in)", binding: heightBinding)
                    .keyboardType(.numberPad)
                    .padding(.bottom)
                
                StyledTextField(title: "State / Location", binding: $state)
                    .padding(.bottom)
                
                StyledMultiSelect(title: "Ethnicity", selected: $ethnicity, options: ContraQuestionaire.ethnicityOptions)
                    .padding(.bottom)
            }
        }
        .onChange( of: height ) { checkDemographicsCompletion() }
        .onChange( of: state ) { checkDemographicsCompletion() }
        .onChange( of: ethnicity ) { checkDemographicsCompletion() }
    }
    
//    MARK: makeMedicalSection
    private func checkMedicalCompletion() {
        self.sceneComplete = !preExistingConditions.isEmpty && !contraception.isEmpty
    }
    
    @ViewBuilder
    private func makeMedicalSelection() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                
                StyledSimpleToggle(title: "Is this your first time using birth control?", isOn: $firstTimeUser)
                    .padding(.bottom)
                
                StyledMultiSelect(title: "Do you have any of the following?", selected: $preExistingConditions, options: ContraQuestionaire.preExistingConditionOptions)
                
                StyledSimpleToggle(title: "Do you have Acne-prone skin?", isOn: $acneProne)
                    .padding(.bottom)
                
                StyledSimpleToggle(title: "Are you on antiseizure medication?", isOn: $antiseizure)
                    .padding(.bottom)
                
                StyledSimpleToggle(title: "Do you smoke?", isOn: $smoker)
                    .padding(.bottom)
                
                StyledSimpleToggle(title: "Do you experience mood swings?", isOn: $moodSwings)
                    .padding(.bottom)
                
                StyledSimpleToggle(title: "Do you have Serious PMS symptoms?", isOn: $PMSSymtoms)
                    .padding(.bottom)
                
                StyledSimpleToggle(title: "Do you have depression predisposition / or a history of mental illness?", isOn: $historOfMentalIllness)
                    .padding(.bottom)
                
                StyledSimpleToggle(title: "Do you have Irregular periods?", isOn: $irregylarPeriods)
                    .padding(.bottom)
                
                StyledMultiSelect(title: "Why are you interested in contraception?", selected: $contraception, options: ContraQuestionaire.contraceptionReasoning)
            }
        }
        .onChange(of: preExistingConditions) { checkMedicalCompletion() }
        .onChange(of: contraception) { checkMedicalCompletion() }
    }
    
//    MARK: Lifestyle
    private func checkLifeStyleCompletion() {
        self.sceneComplete = !frequencyPreference.isEmpty
    }
    
    @ViewBuilder
    private func makeLifeStyleScene() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                
                StyledSimpleToggle(title: "do you struggle with time management or maintaining a regular schedule?", isOn: $struggleWithSchedule)
                    .padding(.bottom)
                
                StyledMultiSelect(title: "Do you prefer a more or less frequent treatment?", selected: $frequencyPreference, options: ContraQuestionaire.frequencyOptions, multiSelect: false)
                    .padding(.bottom)
                
                StyledMultiSelect(title: "Are there any birth control methods that you would not want to try? ", selected: $avoidedBirthControlMethods, options: ContraQuestionaire.birthControlOptions)
                    .padding(.bottom)
            }
        }
        .onChange(of: frequencyPreference) { checkLifeStyleCompletion() }
    }
    
//    MARK: Body
    var body: some View {
        
        ContraScene($activeScene, sceneComplete: $sceneComplete, canRegressScene: true) { submit() } contentBuilder: { scene, edge in
            VStack {
                
                if scene != .splash {
                    Text(scene.getTitle())
                        .bold()
                        .font(.title3)
                        .padding(.bottom)
                }
                
                switch activeScene {
                case .splash: makeSplashScreen()
                case .overview: makeOverviewScene()
                case .demographics: makeDemographicsScene()
                case .medical: makeMedicalSelection()
                case .lifestyle: makeLifeStyleScene()
                }
            }
        }
    }
}


#Preview {
    ContraQuestionaire()
}
