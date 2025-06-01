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
    struct IsGreaterThan<T: Comparable>: Validator {
        let lowerBound: T
        
        func validate(_ value: T) throws(ValidationError) {
            guard value > lowerBound else {
                throw .init(message: "Value is not greater than \(lowerBound)")
            }
        }
    }

    struct IsGreaterThanOrEqualTo<T: Comparable>: Validator {
        let lowerBound: T

        func validate(_ value: T) throws(ValidationError) {
            guard value >= lowerBound else {
                throw .init(message: "Value is not greater than or equal to \(lowerBound)")
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

    struct IsLessThanOrEqualTo<T: Comparable>: Validator {
        let upperBound: T

        func validate(_ value: T) throws(ValidationError) {
            guard value <= upperBound else {
                throw .init(message: "Value is not less than or equal to \(upperBound)")
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
    static func isGreaterThanOrEqualTo(_ lowerBound: Value) -> Self { .init(Validators.Comparable.IsGreaterThanOrEqualTo(lowerBound: lowerBound)) }
    static func isLessThanOrEqualTo(_ upperBound: Value) -> Self { .init(Validators.Comparable.IsLessThanOrEqualTo(upperBound: upperBound)) }
}
