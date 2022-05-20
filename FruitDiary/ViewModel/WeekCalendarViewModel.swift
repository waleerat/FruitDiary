//
//  WeekCalendarViewModel.swift
//  DailyEatenFruit
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import Foundation

class WeekCalendarViewModel: ObservableObject {
    
    @Published var currentDate: String = Date().toString(format: "yyyy-MM-dd")
    @Published var selectedDate: String = Date().toString(format: "yyyy-MM-dd")
    @Published var fistDateOfSelectedWeek: Date = Date()
    @Published var eatenInWeekDays : [WeekDaysModel] = []
    
    var dailyFruitVM = DailyFruitViewModel()
    
    init(){
        getWeekDays()
    }
    
    func previousWeekRange() {
        eatenInWeekDays = []
        fistDateOfSelectedWeek = fistDateOfSelectedWeek.weekPrevious()
        
        let numberOfWeek = Date().numberOfWeek()
        selectedDate = fistDateOfSelectedWeek
                        .dateCalculate(numberOfDays: numberOfWeek)
                        .toString(format: "yyyy-MM-dd")
        
        dailyFruitVM.updateDailyEaten(selectedDate: selectedDate)
        
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
        
        let numberOfWeek = Date().numberOfWeek()
        selectedDate = fistDateOfSelectedWeek
                        .dateCalculate(numberOfDays: numberOfWeek)
                        .toString(format: "yyyy-MM-dd")
        
        dailyFruitVM.updateDailyEaten(selectedDate: selectedDate)
        
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
            let indexDateFormat = dateItem.toString(format: "yyyy-MM-dd")
            
            self.eatenInWeekDays.append(
                WeekDaysModel(id: UUID().uuidString,
                              day: dateItem.toString(format: "EEE"),
                              date: dateItem.toString(format: "dd"),
                              selectedDate: indexDateFormat,
                              isCurrentDay: currentDateFormat == indexDateFormat ? true : false)
            )
            
        }
    }
}
