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
    public struct IsInThePast: Validator {
        public func validate(_ value: Date) throws(ValidationError) {
            guard value < Date() else {
                throw .init(message: "Date is not in the past")
            }
        }
    }
    
    public struct IsInTheFuture: Validator {
        public func validate(_ value: Date) throws(ValidationError) {
            guard value > Date() else {
                throw .init(message: "Date is not in the future")
            }
        }
    }
    
    public struct IsAfter: Validator {
        public let date: Date
        
        public init(date: Date) {
            self.date = date
        }
        
        public func validate(_ value: Date) throws(ValidationError) {
            guard value > date else {
                throw .init(message: "Date is not after \(date)")
            }
        }
    }
    
    public struct IsBefore: Validator {
        public let date: Date
        
        public init(date: Date) {
            self.date = date
        }
        
        public func validate(_ value: Date) throws(ValidationError) {
            guard value < date else {
                throw .init(message: "Date is not before \(date)")
            }
        }
    }
    
    public struct IsBetween: Validator {
        public let startDate: Date
        public let endDate: Date
        
        public init(startDate: Date, endDate: Date) {
            self.startDate = startDate
            self.endDate = endDate
        }
        
        public func validate(_ value: Date) throws(ValidationError) {
            guard value >= startDate else {
                throw .init(message: "Date is before \(startDate)")
            }
            
            guard value <= endDate else {
                throw .init(message: "Date is after \(endDate)")
            }
        }
    }
    
    public struct IsAWeekday: Validator {
        public func validate(_ value: Date) throws(ValidationError) {
            let calendar = Calendar.current
            let weekday = calendar.component(.weekday, from: value)

            // 1 = Sunday, 7 = Saturday in Gregorian calendar
            guard weekday != 1 && weekday != 7 else {
                throw .init(message: "Date is not a weekday")
            }
        }
    }
    
    public struct IsAtTheWeekend: Validator {
        public func validate(_ value: Date) throws(ValidationError) {
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
    public static var  isInThePast: Self { .init(Validators.Date.IsInThePast()) }
    public static var  isInTheFuture: Self { .init(Validators.Date.IsInTheFuture()) }
    public static func isAfter(_ date: Date) -> Self { .init(Validators.Date.IsAfter(date: date)) }
    public static func isBefore(_ date: Date) -> Self { .init(Validators.Date.IsBefore(date: date)) }
    public static func isBetween(_ startDate: Date, _ endDate: Date) -> Self { .init(Validators.Date.IsBetween(startDate: startDate, endDate: endDate)) }
    public static var  isAWeekday: Self { .init(Validators.Date.IsAWeekday()) }
    public static var  isAtTheWeekend: Self { .init(Validators.Date.IsAtTheWeekend()) }
}
