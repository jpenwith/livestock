//
//  Validators.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//
import Foundation


enum Validators {}

extension Validators {
    enum String {}
}

extension Validators.String {
    struct NotEmpty: Validator {
        func validate(_ value: String) throws(ValidationError) {
            guard !value.isEmpty else {
                throw .init(message: "Value is empty")
            }
        }
    }

    struct CountLessThan: Validator {
        let upperBound: Int

        func validate(_ value: String) throws(ValidationError) {
            guard value.count < upperBound else {
                throw .init(message: "\(value) is >= \(upperBound) characters")
            }
        }
    }

    struct CountGreaterThan: Validator {
        let lowerBound: Int

        func validate(_ value: String) throws(ValidationError) {
            guard value.count > lowerBound else {
                throw .init(message: "\(value) is <= \(lowerBound) characters")
            }
        }
    }

    struct CountBetween: Validator {
        let lowerBound: Int
        let upperBound: Int

        func validate(_ value: String) throws(ValidationError) {
            guard value.count >= lowerBound else {
                throw .init(message: "\(value) is < \(lowerBound) characters")
            }
                    
            guard value.count <= upperBound else {
                throw .init(message: "\(value) is > \(upperBound) characters")
            }
        }
    }
    
    struct Matches: Validator {
        let regex: Regex<Substring>
        
        func validate(_ value: String) throws(ValidationError) {
            guard value.wholeMatch(of: regex) != nil else {
                throw .init(message: "\(value) does not match \(regex)")
            }
        }
    }

    struct Contains: Validator {
        let substring: String
        let caseSensitive: Bool
        
        init(substring: String, caseSensitive: Bool = true) {
            self.substring = substring
            self.caseSensitive = caseSensitive
        }
        
        func validate(_ value: String) throws(ValidationError) {
            if caseSensitive {
                guard value.contains(substring) else {
                    throw .init(message: "Value does not contain '\(substring)'")
                }
            } else {
                guard value.lowercased().contains(substring.lowercased()) else {
                    throw .init(message: "Value does not contain '\(substring)' (case insensitive)")
                }
            }
        }
    }
    
    struct AlphaNumeric: Validator {
        func validate(_ value: String) throws(ValidationError) {
            guard value.allSatisfy({ $0.isLetter || $0.isNumber }) else {
                throw .init(message: "Value contains non-alphanumeric characters")
            }
        }
    }
    
    struct Email: Validator {
        func validate(_ value: String) throws(ValidationError) {
            let emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,64}$/.ignoresCase()

            guard value.wholeMatch(of: emailRegex) != nil else {
                throw .init(message: "\(value) is not an email")
            }
        }
    }
}

extension AnyValidator where Value == String {
    static var  notEmpty: Self { .init(Validators.String.NotEmpty()) }
    static func lessThan(_ upperBound: Int) -> Self { .init(Validators.String.CountLessThan(upperBound: upperBound)) }
    static func greaterThan(_ lowerBound: Int) -> Self { .init(Validators.String.CountGreaterThan(lowerBound: lowerBound)) }
    static func between(_ lowerBound: Int, _ upperBound: Int) -> Self { .init(Validators.String.CountBetween(lowerBound: lowerBound, upperBound: upperBound)) }
    static func matches(_ regex: Regex<Substring>) -> Self { .init(Validators.String.Matches(regex: regex)) }
    static var  email: Self { .init(Validators.String.Email()) }
    static func contains(_ substring: String, caseSensitive: Bool = true) -> Self { .init(Validators.String.Contains(substring: substring, caseSensitive: caseSensitive)) }
    static var  alphaNumeric: Self { .init(Validators.String.AlphaNumeric()) }
}

extension Validators {
    enum Collection {}
}

extension Validators.Collection {
    struct NotEmpty<T: Collection>: Validator {
        func validate(_ value: T) throws(ValidationError) {
            guard !value.isEmpty else {
                throw .init(message: "Collection is empty")
            }
        }
    }
    
    struct CountLessThan<T: Collection>: Validator {
        let upperBound: Int
        
        func validate(_ value: T) throws(ValidationError) {
            guard value.count < upperBound else {
                throw .init(message: "Collection count \(value.count) is >= \(upperBound)")
            }
        }
    }
    
    struct CountGreaterThan<T: Collection>: Validator {
        let lowerBound: Int
        
        func validate(_ value: T) throws(ValidationError) {
            guard value.count > lowerBound else {
                throw .init(message: "Collection count \(value.count) is <= \(lowerBound)")
            }
        }
    }
    
    struct CountBetween<T: Collection>: Validator {
        let lowerBound: Int
        let upperBound: Int
        
        func validate(_ value: T) throws(ValidationError) {
            guard value.count >= lowerBound else {
                throw .init(message: "Collection count \(value.count) is < \(lowerBound)")
            }
            
            guard value.count <= upperBound else {
                throw .init(message: "Collection count \(value.count) is > \(upperBound)")
            }
        }
    }
    
    struct ContainsElement<T: Collection>: Validator where T.Element: Equatable {
        let element: T.Element

        func validate(_ value: T) throws(ValidationError) {
            guard value.contains(element) else {
                throw .init(message: "Collection does not contain required element")
            }
        }
    }
    
    struct AllElementsPass<T: Collection>: Validator {
        let elementValidator: (T.Element) throws(ValidationError) -> Void
        
        func validate(_ value: T) throws(ValidationError) {
            for element in value {
                do {
                    try elementValidator(element)
                }
                catch {
                    throw .init(message: "Element validation failed: \(error.message)")
                }
            }
        }
    }
}

extension AnyValidator where Value: Collection {
    static var  notEmpty: Self {
        .init(Validators.Collection.NotEmpty())
    }
    static func lessThan(_ upperBound: Int) -> Self {
        .init(Validators.Collection.CountLessThan(upperBound: upperBound))
    }
    static func greaterThan(_ lowerBound: Int) -> Self {
        .init(Validators.Collection.CountGreaterThan(lowerBound: lowerBound))
    }
    static func between(_ lowerBound: Int, _ upperBound: Int) -> Self {
        .init(Validators.Collection.CountBetween(lowerBound: lowerBound, upperBound: upperBound))
    }
    static func allPass(_ validator: @escaping (Value.Element) throws(ValidationError) -> Void) -> Self {
        .init(Validators.Collection.AllElementsPass(elementValidator: validator))
    }
}

extension AnyValidator where Value: Collection, Value.Element: Equatable {
    static func contains(_ element: Value.Element) -> Self {
        .init(Validators.Collection.ContainsElement(element: element))
    }
}

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

extension Validators {
    enum Numeric {}
}

extension Validators.Numeric {
    enum BinaryInteger {}
}
    
extension Validators.Numeric.BinaryInteger {
    struct IsMultipleOf<T: BinaryInteger>: Validator {
        let divisor: T
        
        func validate(_ value: T) throws(ValidationError) {
            guard value % divisor == 0 else {
                throw .init(message: "Value is not a multiple of \(divisor)")
            }
        }
    }

    struct IsEven<T: BinaryInteger>: Validator {
        func validate(_ value: T) throws(ValidationError) {
            guard value % 2 == 0 else {
                throw .init(message: "Value is not even")
            }
        }
    }
    
    struct IsOdd<T: BinaryInteger>: Validator {
        func validate(_ value: T) throws(ValidationError) {
            guard value % 2 != 0 else {
                throw .init(message: "Value is not odd")
            }
        }
    }
}

extension AnyValidator where Value: BinaryInteger {
    static func isMultipleOf(_ divisor: Value) -> Self { .init(Validators.Numeric.BinaryInteger.IsMultipleOf(divisor: divisor)) }
    static var isEven: Self { .init(Validators.Numeric.BinaryInteger.IsEven()) }
    static var isOdd: Self { .init(Validators.Numeric.BinaryInteger.IsOdd()) }
}

extension Validators {
    enum Comparable {}
}

extension Validators.Comparable {
    struct IsGreaterThan<T: Comparable>: Validator {
        let lowerBound: T
        
        func validate(_ value: T) throws(ValidationError) {
            guard value > lowerBound else {
                throw .init(message: "Value is not greater than \(lowerBound)")
            }
        }
    }
    
    struct IsLessThan<T: Comparable>: Validator {
        let upperBound: T

        func validate(_ value: T) throws(ValidationError) {
            guard value < upperBound else {
                throw .init(message: "Value is not less than \(upperBound)")
            }
        }
    }
    
    struct IsBetween<T: Comparable>: Validator {
        let lowerBound: T
        let upperBound: T
        
        func validate(_ value: T) throws(ValidationError) {
            guard value >= lowerBound else {
                throw .init(message: "Value is less than \(lowerBound)")
            }
            
            guard value <= upperBound else {
                throw .init(message: "Value is greater than \(upperBound)")
            }
        }
    }
}

extension AnyValidator where Value: Comparable {
    static func isGreaterThan(_ lowerBound: Value) -> Self { .init(Validators.Comparable.IsGreaterThan(lowerBound: lowerBound)) }
    static func isLessThan(_ upperBound: Value) -> Self { .init(Validators.Comparable.IsLessThan(upperBound: upperBound)) }
    static func isBetween(_ lowerBound: Value, _ upperBound: Value) -> Self { .init(Validators.Comparable.IsBetween(lowerBound: lowerBound, upperBound: upperBound)) }
}

extension Validators {
    enum NumericAndComparable {}
}

extension Validators.NumericAndComparable {
    struct IsPositive<T: Numeric & Comparable>: Validator {
        func validate(_ value: T) throws(ValidationError) {
            guard value > T.zero else {
                throw .init(message: "Number is not positive")
            }
        }
    }
    
    struct IsNegative<T: Numeric & Comparable>: Validator {
        func validate(_ value: T) throws(ValidationError) {
            guard value < T.zero else {
                throw .init(message: "Number is not negative")
            }
        }
    }
}

extension AnyValidator where Value: Numeric & Comparable {
    static var  isPositive: Self { .init(Validators.NumericAndComparable.IsPositive()) }
    static var  isNegative: Self { .init(Validators.NumericAndComparable.IsNegative()) }
}
