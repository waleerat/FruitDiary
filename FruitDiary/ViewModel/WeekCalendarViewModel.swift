//
//  WeekCalendarViewModel.swift
//  DailyEatenFruit
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import Foundation

class WeekCalendarViewModel: ObservableObject {
    @Published var fistDateOfSelectedWeek: Date = Date()
    @Published var eatenInWeekDays : [WeekDaysModel] = [] 
    
    init(){
        getWeekDays()
    }
    
    func previousWeekRange() {
        eatenInWeekDays = []
        fistDateOfSelectedWeek = fistDateOfSelectedWeek.weekPrevious()
        getWeekDays()
    }
    
    func currentWeekRange() {
        eatenInWeekDays = []
        fistDateOfSelectedWeek = Date()
        getWeekDays()
    }
    
    func nextWeekRange(){
        eatenInWeekDays = []
        fistDateOfSelectedWeek = fistDateOfSelectedWeek.weekNext()
        getWeekDays()
    }
    
    func getMonth() -> String {
        return fistDateOfSelectedWeek.toString(format: "LLLL yyyy")
    }
    
    func getWeekDays(){
        
        let startDate = self.fistDateOfSelectedWeek.firstDateOfWeek()
        
        for index in 0..<7{
            let dateItem = startDate.dateCalculate(numberOfDays: index)
            
            let currentDateFormat = Date().toString(format: "yyyy-MM-dd")
            let itemDateFormat = dateItem.toString(format: "yyyy-MM-dd")
            
            self.eatenInWeekDays.append(
                WeekDaysModel(id: UUID().uuidString,
                              day: dateItem.toString(format: "EEE"),
                              date: dateItem.toString(format: "dd"),
                              entries: nil,
                              isCurrentDay: currentDateFormat == itemDateFormat ? true : false)
            )
            
        }
    }
}
