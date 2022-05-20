//
//  Date+Extension.swift
//  DailyEatenFruit
//
//  Created by Waleerat Gottlieb on 2022-05-19.
//

import Foundation

extension Date {
    
    func dateToString() -> String {
        let formatter = DateFormatter()
        return formatter.string(from: self)
    }
 
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
   
    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    // MARK: - Day
    func dateNext() -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return nextDate ?? Date()
    }
    
    func datePrevious() -> Date {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return previousDate ?? Date()
    }
    
    func dateCalculate(numberOfDays: Int)-> Date {
        let addDate = Calendar.current.date(byAdding: .day, value: numberOfDays, to: self)
        return addDate ?? Date()
    }
 
    
    // MARK: - Week
    func weekPrevious() -> Date {
        let previousDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: self)
        return previousDate ?? Date()
    }
    
    func weekCurrent() -> Date {
        let nextDate = Calendar.current.date(byAdding: .weekOfYear, value: 0, to: self)
        return nextDate ?? Date()
    }
    
    func weekNext() -> Date {
        let nextDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: self)
        return nextDate ?? Date()
    }
    
    func WeeknumberOfYear() -> Int {
        let cal = Calendar(identifier: .iso8601)
        let date = ISO8601DateFormatter().date(from: self.dateToString())
        return cal.component(.weekday, from: date ?? Date())
    }
    
    func firstDateOfWeek() -> Date {
        let calender = Calendar.current
        let week = calender.dateInterval(of: .weekOfMonth, for: self)
        if let  start = week?.start {
            return start
        } else {
            return Date()
        }
    }

    func lastDateOfWeek() -> Date {
        let calender = Calendar.current
        let week = calender.dateInterval(of: .weekOfMonth, for: self)
        if let  end = week?.end {
            return end
        } else {
            return Date()
        }
    }
    
    func weekRange() -> DateInterval? {
        let calender = Calendar.current
        return calender.dateInterval(of: .weekOfMonth, for: self)
    }
    
    func numberOfWeek() -> Int {
        let cal = Calendar(identifier: .iso8601)
        let date = ISO8601DateFormatter().date(from: self.dateToString())
        return cal.component(.weekday, from: date ?? Date())
    }
    
    // MARK: - Month
    func firstDateOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year,.month], from: self)
        components.day = 2
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }
    
    func lastDateOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.firstDateOfMonth())!
    }
    
    func monthPrevious() -> Date {
        return self.MonthCalculate(numberOfMonths: 1)
    }
    func monthNext() -> Date {
        return self.MonthCalculate(numberOfMonths: -1)
    }
    
    func MonthCalculate(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
        return endDate ?? Date()
    }
 
    
    // MARK: - Year
    func yearPrevious() -> Date {
        return self.YearsCalculate(numberOfYears: 1)
    }
    func yearNext() -> Date {
        return self.YearsCalculate(numberOfYears: -1)
    }
    
    func YearsCalculate(numberOfYears: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .year, value: numberOfYears, to: self)
        return endDate ?? Date()
    }
}
