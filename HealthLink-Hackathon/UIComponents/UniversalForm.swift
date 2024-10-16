//
//  UniversalForm.swift
//  Recall
//
//  Created by Brian Masse on 7/19/23.
//

import Foundation
import SwiftUI
import UIUniversals

struct RecallIcon: View {
    
    let icon: String
    let bold: Bool
    
    init(_ icon: String, bold: Bool = true) {
        self.icon = icon
        self.bold = bold
    }
    
    var body: some View {
        Image(systemName: icon)
            .bold(bold)
    }
}

//MARK: StyledTextField
struct StyledTextField: View {
    
    let title: String
    let binding: Binding<String>
    let prompt: String
    let clearable: Bool
    let multiLine: Bool
    
    @Binding var isFocussed: Bool
    
    init( title: String, binding: Binding<String>, prompt: String = "", clearable: Bool = false, multiLine: Bool = false, isFocussed: Binding<Bool> = .constant(false) ) {
        self.title = title
        self.binding = binding
        self.clearable = clearable
        self.multiLine = multiLine
        self.prompt = prompt
        self._isFocussed = isFocussed
    }
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState var focused: Bool
    @State var showingClearButton: Bool = false
    
    @ViewBuilder
    private func makeTextField() -> some View {
        if multiLine { TextField(prompt, text: binding, axis: .vertical) }
        else { TextField(prompt, text: binding) }
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            if !title.isEmpty {
                Text(title)
                    .font(.title2)
                    .bold()
                .padding(.trailing)
            }
                
            makeTextField()
                .focused($focused)
                .lineLimit(1...)
                .frame(maxWidth: .infinity)
                .padding( .trailing, 5 )
                .tint(Colors.getAccent(from: colorScheme) )
//                .font(Font.custom(AndaleMono.shared.postScriptName, size: Constants.UIDefaultTextSize))
            
                .rectangularBackground(style: .secondary)
                .onChange(of: self.focused) {
                    withAnimation {
                        self.showingClearButton = self.focused
                        self.isFocussed = self.focused
                    }
                }
                .onChange(of: self.isFocussed) {
                    self.focused = self.isFocussed
                }
            
            if showingClearButton && clearable && !binding.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                VStack {
                    HStack {
                        Spacer()
                        UniversalText( "clear", size: Constants.UIDefaultTextSize, font: Constants.mainFont )
                        RecallIcon("xmark")
                        Spacer()
                        
                    }
                    .rectangularBackground(style: .secondary)
                    .onTapGesture {
                        withAnimation { binding.wrappedValue = "" }
                    }
                }.transition(.opacity)
            }
        }
    }
}

//MARK: StyleSlider
struct StyledSlider: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let minValue: Float
    let maxValue: Float
    
    let binding: Binding<Float>
    let strBinding: Binding<String>
    
    let textFieldWidth: CGFloat
    
    var body: some View {
        HStack {
            Slider(value: binding, in: minValue...maxValue )
                .tint(Colors.getAccent(from: colorScheme))
            
            TextField("", text: strBinding)
                .rectangularBackground(style: .secondary)
                .universalTextField()
                .frame(width: textFieldWidth)
        }
    }
}

//MARK: SlideWithPrompt
struct SliderWithPrompt: View {
    
    let label: String
    
    let minValue: Float
    let maxValue: Float
    
    let binding: Binding<Float>
    let strBinding: Binding<String>
    
    let textFieldWidth: CGFloat
    let size: Double
    
    init(label: String, minValue: Float, maxValue: Float, binding: Binding<Float>, strBinding: Binding<String>, textFieldWidth: CGFloat, size: Double = (Constants.UISubHeaderTextSize - 5)) {
        
        self.label = label
        self.minValue = minValue
        self.maxValue = maxValue
        self.binding = binding
        self.strBinding = strBinding
        self.textFieldWidth = textFieldWidth
        self.size = size
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            UniversalText(label, size: size, font: Constants.titleFont)
            
            StyledSlider(minValue: minValue, maxValue: maxValue, binding: binding, strBinding: strBinding, textFieldWidth: textFieldWidth)
        }
    }
}

//MARK: MultiSelect
struct StyledMultiSelect: View {
    
    @Binding var selected: [String]
    
    let options: [String]
    let title: String
    
    let multiselect: Bool
    
    init( title: String, selected: Binding<[String]>, options: [String], multiSelect: Bool = true ) {
        self.title = title
        self._selected = selected
        self.options = options
        self.multiselect = true
    }
    
    private func optionIsSelected(_ option: String) -> Bool {
        selected.contains(option)
    }
    
    private func toggleOption( _ option: String ) {
        if !multiselect { self.selected = [option] }
        else {       
            if let index = selected.firstIndex(of: option) {
                selected.remove(at: index)
            } else { selected.append(option) }
        }
    }
    
    var body: some View {
        VStack(alignment : .leading) {
            Text(title)
                .font(.title2)
                .bold()
            
            Text("select all that apply")
                .opacity(0.75 )
                .padding(.bottom, 7)
            
            VStack {
                ForEach( 0..<options.count, id: \.self ) { i in
                    let option: String = options[i]
                    
                    UniversalButton {
                        HStack {
                            ContraIcon( optionIsSelected(option) ? "circle.fill" : "circle")
                            
                            Text( option )
                            
                            Spacer()
                        }
                        .rectangularBackground(style: .secondary)
                    } action: { toggleOption(option) }
                }
            }
        }
    }
}

struct StyledSimpleToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        
        UniversalButton {
            HStack {
                Text(title)
                    .bold()
                    .font(.title2)
                
                Spacer()
                
                ContraIcon(isOn ? "circle.fill" : "circle")
            }
            .contentShape(Rectangle())
            
        } action: { isOn.toggle() }
    }
}

private struct test: View {
    @State private var selection: [String] = []
    
    var body: some View {
        StyledMultiSelect(title: "Select", selected: $selection, options: ["option 1 ", "option 2"])
        
    }
}

#Preview(body: {
    test()
})

//MARK: Time Selector
//Time selectors can either be a single slider, or, if the fineTimeSelection preference is selected, then it will use 2 sliders to make precise time slection easier
//struct TimeSelector: View {
//    
//    let label: String
//    @Binding var time: Date
//    @State var showingFineSelector: Bool = false
//    
//    let size: Double
//    
//    static let fineSnappingInterval: Double = 5
//    
//    init( label: String, time: Binding<Date>, size: Double = Constants.UISubHeaderTextSize ) {
//        self.label = label
//        self._time = time
//        self.size = size
//    }
//    
////    when using the fine time slider, this function will round the slide value to a specific interval. The default is set to 5
//    private func roundFineTime( _ value: Double ) -> Double {
//        (value / TimeSelector.fineSnappingInterval).rounded(.down) * TimeSelector.fineSnappingInterval
//    }
//    
//    private var timeBinding: Binding<Float> {
//        Binding { Float(time.getHoursFromStartOfDay().round(to: 2)) }
//        set: { newValue, _ in
//            time = time.dateBySetting(hour: Double(newValue)).round(to: RecallModel.index.dateSnapping)
//        }
//    }
//    
//    private var timeLabel: Binding<String> {
//        Binding { time.formatted(date: .omitted, time: .shortened) }
//        set: { newValue, _ in }
//    }
//    
////    fine time bindings
//    private var fineTimeHourBinding: Binding<Float> {
//        Binding { Float(time.getHoursFromStartOfDay().rounded(.down) ) }
//        set: { newValue, _ in time = time.dateBySetting(hour: Double(newValue), ignoreMinutes: true) }
//    }
//    
//    private var fineTimeBinding: Binding<Float> {
//        Binding { Float( roundFineTime(time.getMinutesFromStartOfHour()) ) }
//        set: { newValue, _ in
//            time = time.dateBySetting(minutes:  roundFineTime( Double(newValue) )  )
//        }
//    }
//    
//    private var fineTimeLabel: Binding<String> {
//        Binding { "\(Int(roundFineTime( time.getMinutesFromStartOfHour() )))" }
//        set: { newValue, _ in }
//    }
//    
//    var body: some View {
//        
//        VStack {
//            
//            HStack {
//               
//                UniversalText(label,
//                              size: size,
//                              font: Constants.titleFont)
//                    .padding(.trailing, 5)
//                
//                Spacer()
//            }
//        
//            if !showingFineSelector {
//                StyledSlider(minValue: 0,
//                             maxValue: 23.75,
//                             binding: timeBinding,
//                             strBinding: timeLabel,
//                             textFieldWidth: 120)
//                
//            } else {
//                StyledSlider(minValue: 0,
//                             maxValue: 23.75,
//                             binding: fineTimeHourBinding,
//                             strBinding: timeLabel,
//                             textFieldWidth: 120)
//                
//                StyledSlider(minValue: 0,
//                             maxValue: 55,
//                             binding: fineTimeBinding,
//                             strBinding: fineTimeLabel,
//                             textFieldWidth: 120)
//            }
//        }
//    }
//}

//MARK: Length Selector
//like a TimeSelector, LengthSelectors can either be a single slider, or, if the fineTimeSelection preference is selected, then it will use 2 sliders to make precise time slection easier
//struct LengthSelector: View {
//    
//    let label: String
//    let fontSize: Double
//    let onSetLengthAction: (Double) -> Void
//    let allowFineToggle: Bool
//    
//    @Binding var length: Double
//    @State var showingFineSelector: Bool = RecallModel.index.defaultFineTimeSelector
//    
//    init( _ label: String, length: Binding<Double>, fontSize: Double = Constants.formQuestionTitleSize, allowFineToggle: Bool = true, onSetLengthAction: @escaping (Double) -> Void = { _ in } ) {
//        self.label = label
//        self._length = length
//        self.fontSize = fontSize
//        self.allowFineToggle = allowFineToggle
//        self.onSetLengthAction = onSetLengthAction
//    
//    }
//    
////    returns (hours, minutes)
//    private func getComponents() -> (Double, Double) {
//        let hours = length / Constants.HourTime
//        let intHours = hours.rounded(.down)
//        let minutes = (hours - intHours) * 60
//        return (intHours, minutes)
//    }
//    
////    Standard Bindings
//    private var eventLengthBinding: Binding<Float> {
//        Binding { Float( length ) }
//        set: { newValue, _ in
//            let multiplier = 15 * Constants.MinuteTime
//            length = (Double( newValue ) / multiplier).rounded(.down) * multiplier
//            onSetLengthAction(length)
//        }
//    }
//    
//    private var eventLengthLabelBinding: Binding<String> {
//        Binding {
//            let components = getComponents()
//            return "\(Int(components.0)) HR \(Int(components.1)) mins"
//        } set: { newValue, _ in }
//    }
//    
////    fine bindings
//    private var hourBinding: Binding<Float> {
//        Binding { Float(getComponents().0 * Constants.HourTime) }
//        set: { newValue, _ in
//            let minutes = getComponents().1
//            let roundedHours = (Double(newValue) / Constants.HourTime).rounded(.down) * Constants.HourTime
//            length = roundedHours + ( minutes * Constants.MinuteTime )
//            onSetLengthAction(length)
//        }
//    }
//    
//    private var minuteBinding: Binding<Float> {
//        Binding { Float(getComponents().1 * Constants.MinuteTime) }
//        set: { newValue, _ in
//            let hours = getComponents().0
//            let scalar: Double = (15 * Constants.MinuteTime )
//            let rounded = (Double(newValue) / scalar).rounded(.down) * scalar
//            length = ( hours * Constants.HourTime ) + rounded
//            onSetLengthAction(length)
//        }
//    }
//    
//    private var hourLabelBinding: Binding<String> {
//        Binding { "\(Int(getComponents().0)) HR" }
//        set: { _, _ in }
//    }
//    
//    private var minuteLabelBinding: Binding<String> {
//        Binding { "\(Int(getComponents().1)) mins" }
//        set: { _, _ in }
//    }
//    
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                UniversalText( label, size: fontSize, font: Constants.titleFont )
//                Spacer()
//                
//                if allowFineToggle {
//                    ConditionalLargeRoundedButton(title: "", icon: "camera.filters", wide: false, allowTapOnDisabled: true) { showingFineSelector } action: {
//                        withAnimation { showingFineSelector.toggle() }
//                    }
//                }
//            }
//            
//            if showingFineSelector && allowFineToggle {
//                StyledSlider(minValue: 0,
//                             maxValue: Float(5 * Constants.HourTime),
//                             binding: hourBinding,
//                             strBinding: hourLabelBinding,
//                             textFieldWidth: 115)
//                
//                StyledSlider(minValue: 0,
//                             maxValue: Float(45 * Constants.MinuteTime),
//                             binding: minuteBinding,
//                             strBinding: minuteLabelBinding,
//                             textFieldWidth: 115)
//                
//            } else {
//                StyledSlider(minValue: Float(15 * Constants.MinuteTime),
//                             maxValue: Float(5 * Constants.HourTime),
//                             binding: eventLengthBinding,
//                             strBinding: eventLengthLabelBinding,
//                             textFieldWidth: 150)
//            }
//        }
//    }
//}

//MARK: StyledToggle
struct StyledToggle<C: View>: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let title: C
    let wide: Bool
    let binding: Binding<Bool>
    
    init( _ binding: Binding<Bool>, wide: Bool = true, titleBuilder: () -> C ) {
        self.binding = binding
        self.title = titleBuilder()
        self.wide = wide
    }
    
    var body: some View {
        
        HStack {
            title
            
            if wide { Spacer() }
            
            Toggle("", isOn: binding)
                .tint(Colors.getAccent(from: colorScheme))
        }
    }
}

//MARK: StyledDatePicker
//In the future, this will be entirley custom built. For now it is relying on Apple's default DatePicker
struct StyledDatePicker: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var date: Date
    let title: String
    let fontSize: CGFloat
    
    init( _ date: Binding<Date>, title: String, fontSize: CGFloat = Constants.UISubHeaderTextSize - 5 ) {
        self._date = date
        self.title = title
        self.fontSize = fontSize
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .bold()
            
            DatePicker(selection: $date, displayedComponents: .date) {
                UniversalText( "select", size: Constants.UIDefaultTextSize, font: Constants.titleFont )
            }
            .tint(Colors.getAccent(from: colorScheme))
            .rectangularBackground(style: .secondary)
        }
    }
}
