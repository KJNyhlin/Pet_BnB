//
//  DateManager.swift
//  Pet_BnB
//
//  Created by Jonas Bondesson on 2024-05-22.
//

import Foundation

class DateManager{
    let calendar = Calendar.current
  
    func getWeekDays(for date: Date) -> [Date] {

        let interval = calendar.dateInterval(of: .weekOfYear, for: date)
        var weekDays: [Date] = []
        if let interval = interval{
            for i in 0..<7{
                if let dateOfWeek = calendar.date(byAdding: .day, value: i, to: interval.start){
                    weekDays.append(dateOfWeek)
                }
            }
        }
        return weekDays
    }

    func getWeekNumber(from date: Date) -> Int{

        let weekNumber = calendar.component(.weekOfYear, from: date)
        return weekNumber
    }
    
    func getDaysOfMonth(from date: Date) -> [Date]{
        return date.getDaysInMonth
    }
    
    
    func getHourMinuteDateComponents(from date: Date) -> DateComponents{

        return calendar.dateComponents([.hour, .minute], from: date)
    }
    

    func getDate(numberOfDaysFrom: Int, from startDate: Date) -> Date {

        var dateComponents = DateComponents()
        dateComponents.day = numberOfDaysFrom
        if let newDate = calendar.date(byAdding: dateComponents, to: startDate){
            return newDate
        }
        return startDate
    }
    
    func getFirstWeekdayIndex(from days: [Date]) -> Int{
        guard let firstDay = days.first else {return 0}
        let weekday = Calendar.current.component(.weekday, from: firstDay + 1)
        return (weekday + 5) % 7
    }
    
    func isSameDay(firstDate: Date, secoundDate: Date) -> Bool{
        calendar.isDate(firstDate, equalTo: secoundDate, toGranularity: .day)
    }
}


extension Date {
    var startDateOfMonth: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = calendar.dateComponents([.year, .month], from: self)
        guard let date = calendar.date(from: components) else {
            fatalError("Unable to get start date from date")
        }
        return date
    }
    

    var endDateOfMonth: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = DateComponents(month: 1, day: -1)
        guard let date = calendar.date(byAdding: components, to: self.startDateOfMonth) else {
            fatalError("Unable to get end date from date")
        }
        return date
    }
    var formattedForBooking: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        
        var newComponents = DateComponents()
        newComponents.year = components.year
        newComponents.month = components.month
        newComponents.day = components.day
        newComponents.hour = 12
        newComponents.minute = 0
        
        guard let date = calendar.date(from: newComponents) else {
            fatalError("Unable to convert date")
        }
        return date
    }
    
    var formattedForStartDate: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        
        var newComponents = DateComponents()
        newComponents.year = components.year
        newComponents.month = components.month
        newComponents.day = components.day
        newComponents.hour = 0
        newComponents.minute = 1
        
        guard let date = calendar.date(from: newComponents) else {
            fatalError("Unable to convert date")
        }
        return date
    }
    var formattedForEndDate: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        
        var newComponents = DateComponents()
        newComponents.year = components.year
        newComponents.month = components.month
        newComponents.day = components.day
        newComponents.hour = 23
        newComponents.minute = 59
        
        guard let date = calendar.date(from: newComponents) else {
            fatalError("Unable to convert date")
        }
        return date
    }
    
    var getDaysInMonth: [Date]{
        let startDate = self.startDateOfMonth
        let endDate = self.endDateOfMonth
        
        var currentDate = startDate
        
        var allDays: [Date] = []
        while currentDate <= endDate{
            allDays.append(currentDate)
            if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate){
                currentDate = newDate
                
            }
        }
        return allDays
    }
    
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
        
    }
    
    func nextMonth(_ monthsToMove: Int = 1) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: monthsToMove, to: self)
    }
    
    func previousMonth(_ monthsToMove: Int = 1) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -monthsToMove, to: self)
    }
    
    func isDateInMonth(date: Date, selectedMonth: Date) ->Bool {
        print(date.formatted(.dateTime.month()))
        print(selectedMonth.formatted(.dateTime.month()))
        return date.formatted(.dateTime.month()) == selectedMonth.formatted(.dateTime.month())
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
