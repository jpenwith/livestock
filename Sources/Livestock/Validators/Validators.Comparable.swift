//
//  Validators.Comparable.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

extension Validators {
    enum Comparable {}
}

extension Validators.Comparable {
    public struct IsGreaterThan<T: Comparable>: Validator {
        public let lowerBound: T
        
        public init(lowerBound: T) {
            self.lowerBound = lowerBound
        }
        
        public func validate(_ value: T) throws(ValidationError) {
            guard value > lowerBound else {
                throw .init(message: "Value is not greater than \(lowerBound)")
            }
        }
    }

    public struct IsGreaterThanOrEqualTo<T: Comparable>: Validator {
        public let lowerBound: T
        
        public init(lowerBound: T) {
            self.lowerBound = lowerBound
        }

        public func validate(_ value: T) throws(ValidationError) {
            guard value >= lowerBound else {
                throw .init(message: "Value is not greater than or equal to \(lowerBound)")
            }
        }
    }

    public struct IsLessThan<T: Comparable>: Validator {
        public let upperBound: T
        
        public init(upperBound: T) {
            self.upperBound = upperBound
        }

        public func validate(_ value: T) throws(ValidationError) {
            guard value < upperBound else {
                throw .init(message: "Value is not less than \(upperBound)")
            }
        }
    }

    public struct IsLessThanOrEqualTo<T: Comparable>: Validator {
        public let upperBound: T

        public init(upperBound: T) {
            self.upperBound = upperBound
        }

        public func validate(_ value: T) throws(ValidationError) {
            guard value <= upperBound else {
                throw .init(message: "Value is not less than or equal to \(upperBound)")
            }
        }
    }

    public struct IsBetween<T: Comparable>: Validator {
        public let lowerBound: T
        public let upperBound: T
        
        public init(lowerBound: T, upperBound: T) {
            self.lowerBound = lowerBound
            self.upperBound = upperBound
        }
        
        public func validate(_ value: T) throws(ValidationError) {
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
    public static func isGreaterThan(_ lowerBound: Value) -> Self { .init(Validators.Comparable.IsGreaterThan(lowerBound: lowerBound)) }
    public static func isLessThan(_ upperBound: Value) -> Self { .init(Validators.Comparable.IsLessThan(upperBound: upperBound)) }
    public static func isBetween(_ lowerBound: Value, _ upperBound: Value) -> Self { .init(Validators.Comparable.IsBetween(lowerBound: lowerBound, upperBound: upperBound)) }
    public static func isGreaterThanOrEqualTo(_ lowerBound: Value) -> Self { .init(Validators.Comparable.IsGreaterThanOrEqualTo(lowerBound: lowerBound)) }
    public static func isLessThanOrEqualTo(_ upperBound: Value) -> Self { .init(Validators.Comparable.IsLessThanOrEqualTo(upperBound: upperBound)) }
}
