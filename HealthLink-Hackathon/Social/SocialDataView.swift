//
//  SocialDataView.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI
import Charts
import UIUniversals

struct FavorabilityData {
    let id = UUID()
    
    let favorityability: Int
    let totalRatings: Int
    
    static func mockData() -> [FavorabilityData] {
        var data: [FavorabilityData] = []
        
        for i in 1...5 {
            let totalRatings = Int.random(in: 0..<1000)
            data.append(.init(favorityability: i, totalRatings: totalRatings * i * 2))
        }
        
        return data
    }
}

//MARK: FavorabilityRatingChart
struct FavorabilityRatingsChart: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var favorabilityData: [FavorabilityData] = FavorabilityData.mockData()
    
    var body: some View {
        GeometryReader { geo in
            
            VStack(alignment: .leading) {
                Text("Favorability Ratings for Yaz")
                    .bold()
                
                let width = (geo.size.width - (4 * 10) - 150) / 5
                
                Chart {
                    
                    ForEach( favorabilityData, id: \.id ) { info in
                        BarMark(x: .value("Favorability", info.favorityability),
                                y: .value("Total Ratings", info.totalRatings),
                                width: .init(floatLiteral:  width ))
                        
                        .foregroundStyle(Colors.getAccent(from: colorScheme))
                        .annotation(position: .top, alignment: .center) {
                            Text("\(info.totalRatings)")
                        }
                        .cornerRadius(12)
                    }
                    
                }
            }
        }
        .frame(height: 250)
        .rectangularBackground(style: .secondary)
    }
}

//MARK: SocialDataView
struct ContraProductRating: Identifiable {
    let id = UUID()
    
    let name: String
    let date: Date
    let rating: Int
    let review: String
}

let productRatings: [ContraProductRating] = [
    .init(name: "Anonymous",
          date: .now - Constants.DayTime * 2,
          rating: 4,
          review: "Initially experienced an increase in anxiety, but after about a week it moderated and has worked great ever since!"),
    
    .init(name: "Debrah",
          date: .now - Constants.DayTime * 5,
          rating: 4,
          review: "Great solution for me, non-intrsuive and effective. I'm so glad I did research and found the right product"),
]

struct SocialDataView: View {
    
    let ratings: [ContraProductRating]
    
//    MARK: Ratings
    @ViewBuilder
    private func makeRating(_ rating: ContraProductRating) -> some View {
        VStack(alignment: .leading) {
            HStack {
                ContraIcon("square.and.pencil")
                    .font(.title3)
                
                VStack(alignment: .leading) {
                    Text(rating.name)
                        .bold()
                        .font(.title3)
                    
                    Text(rating.date.formatted(date: .numeric, time: .omitted))
                        .font(.caption)
                        .opacity(0.75)
                }
                
                Spacer()
            }
            .padding(.bottom, 7)
            
            Text("\(rating.rating) / 5")
                .bold()
                .padding(.bottom, 7)
            
            Text(rating.review)
                .font(.callout)
                .opacity(0.75)
        }
        .frame(width: 180, height: 230)
        .rectangularBackground(style: .secondary)
    }
    
//    MARK: Body
    var body: some View {
        VStack(alignment: .leading) {
            Text("Explore other experiences")
                .bold()
                .font(.title2)
            
            FavorabilityRatingsChart()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach( ratings, id: \.id ) { rating in
                            
                        makeRating(rating)
                    }
                }
            }
        }
    }
}

#Preview {
    SocialDataView(ratings: productRatings)
}

