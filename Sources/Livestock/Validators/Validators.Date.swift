//
//  Validators.Date.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//
import Foundation

extension Validators {
    enum Date {}
}

extension Validators.Date {
    struct IsPast: Validator {
        func validate(_ value: Date) throws(ValidationError) {
            guard value < Date() else {
                throw .init(message: "Date is not in the past")
            }
        }
    }
    
    struct IsFuture: Validator {
        func validate(_ value: Date) throws(ValidationError) {
            guard value > Date() else {
                throw .init(message: "Date is not in the future")
            }
        }
    }
    
    struct IsAfter: Validator {
        let date: Date
        
        func validate(_ value: Date) throws(ValidationError) {
            guard value > date else {
                throw .init(message: "Date is not after \(date)")
            }
        }
    }
    
    struct IsBefore: Validator {
        let date: Date
        
        func validate(_ value: Date) throws(ValidationError) {
            guard value < date else {
                throw .init(message: "Date is not before \(date)")
            }
        }
    }
    
    struct IsBetween: Validator {
        let startDate: Date
        let endDate: Date
        
        func validate(_ value: Date) throws(ValidationError) {
            guard value >= startDate else {
                throw .init(message: "Date is before \(startDate)")
            }
            
            guard value <= endDate else {
                throw .init(message: "Date is after \(endDate)")
            }
        }
    }
    
    struct IsWeekday: Validator {
        func validate(_ value: Date) throws(ValidationError) {
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: value)
            
            // 1 = Sunday, 7 = Saturday in Gregorian calendar
            guard weekday != 1 && weekday != 7 else {
                throw .init(message: "Date is not a weekday")
            }
        }
    }
    
    struct IsWeekend: Validator {
        func validate(_ value: Date) throws(ValidationError) {
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: value)
            
            // 1 = Sunday, 7 = Saturday in Gregorian calendar
            guard weekday == 1 || weekday == 7 else {
                throw .init(message: "Date is not a weekend")
            }
        }
    }
}

extension AnyValidator where Value == Date {
    static var  isPast: Self { .init(Validators.Date.IsPast()) }
    static var  isFuture: Self { .init(Validators.Date.IsFuture()) }
    static func isAfter(_ date: Date) -> Self { .init(Validators.Date.IsAfter(date: date)) }
    static func isBefore(_ date: Date) -> Self { .init(Validators.Date.IsBefore(date: date)) }
    static func isBetween(_ startDate: Date, _ endDate: Date) -> Self { .init(Validators.Date.IsBetween(startDate: startDate, endDate: endDate)) }
    static var  isWeekday: Self { .init(Validators.Date.IsWeekday()) }
    static var  isWeekend: Self { .init(Validators.Date.IsWeekend()) }
}
