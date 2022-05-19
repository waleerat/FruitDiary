//
//  WeeklyCalendaerHeader.swift
//  DailyEatenFruit
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import SwiftUI

struct WeeklyCalendaerHeader: View {
    @EnvironmentObject var weekCalendarVM: WeekCalendarViewModel
    
    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                weekCalendarVM.previousWeekRange()
            }, label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(.vertical,7)
                    .padding(.horizontal,20)
                    .modifier(ArrowModifier())
            })
            .padding(.top)
            
            Spacer()
            
            Button(action: {
                weekCalendarVM.currentWeekRange()
            }, label: {
                Text(weekCalendarVM.getMonth())
                    .modifier(TextTitleModifier(isBold: true))
                    .padding(.vertical)
            })
            .padding(.top)
            
            Spacer()
            
            Button(action: {
                weekCalendarVM.nextWeekRange()
            }, label: {
                Image(systemName: "arrow.right")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding(.vertical,7)
                    .padding(.horizontal,20)
                    .modifier(ArrowModifier())
            })
            .padding(.top)
            
        }
        .padding(.horizontal)
    }
}

struct ArrowView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyCalendaerHeader()
    }
}
