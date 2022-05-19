//
//  WeekCalendarView.swift
//  DailyEatenFruit
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import SwiftUI

struct WeeklyCalendar: View {
    @EnvironmentObject var weekCalendarVM: WeekCalendarViewModel
    
    var body: some View {
        
        VStack {
            WeeklyCalendaerHeader().environmentObject(weekCalendarVM)
            HStack(spacing: 0){
                
                ForEach(weekCalendarVM.eatenInWeekDays){ eatenItem in
                    
                    VStack(spacing: 12){
                        
                        Text(eatenItem.day)
                            .fontWeight(.bold)
                            .foregroundColor(eatenItem.isCurrentDay ? kConfig.color.foregroundRevert.opacity(0.8) : kConfig.color.foreground)
                        
                        Text(eatenItem.date)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(eatenItem.isCurrentDay ? kConfig.color.foregroundRevert : kConfig.color.foreground)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(kConfig.color.currentDateBackground.opacity(eatenItem.isCurrentDay ? 1 : 0))
                    .clipShape(Capsule())
                    .onTapGesture {
                        withAnimation{
                           // currentDay = week
                        }
                    }
                }
            }
            
            Spacer()
        }//:VStack
    }
}

struct WeekCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyCalendar()
    }
}
