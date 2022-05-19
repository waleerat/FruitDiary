//
//  ContentView.swift
//  DailyEatenFruit
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var weekCalendarVM: WeekCalendarViewModel
    @StateObject var dailyFruitVM = DailyFruitViewModel()
    
    var body: some View {
        VStack {
            WeeklyCalendar()
               .environmentObject(weekCalendarVM)
            Spacer()
        }
         
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
