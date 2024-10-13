//
//  SocialPageView.swift
//  HealthLink-Hackathon
//
//  Created by Brian Masse on 10/12/24.
//

import Foundation
import SwiftUI

struct SocialPageView: View {
    
    
//    MARK: Body
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Social")
                .font(.title)
                .bold()
         
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    SocialDataView(ratings: productRatings)
                        .padding(.bottom)
                    
                    SocialFormView()
                }
                .padding(.bottom, 100)
            }
        }
        .padding()
        .contraBackgorund()
    }
}



#Preview {
    
    SocialPageView()
    
}
