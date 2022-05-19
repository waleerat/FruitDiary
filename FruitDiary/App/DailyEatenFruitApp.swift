//
//  DailyEatenFruitApp.swift
//  DailyEatenFruit
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import SwiftUI

@main
struct DailyEatenFruitApp: App {
    @StateObject var weekCalendarVM = WeekCalendarViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(weekCalendarVM)
        }
    }
}
