//
//  Validators.NumericAndComparable.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

extension Validators {
    public enum NumericAndComparable {}
}

extension Validators.NumericAndComparable {
    public struct IsPositive<T: Numeric & Comparable>: Validator {
        public func validate(_ value: T) throws(ValidationError) {
            guard value > T.zero else {
                throw .init(message: "Number is not positive")
            }
        }
    }
    
    public struct IsNegative<T: Numeric & Comparable>: Validator {
        public func validate(_ value: T) throws(ValidationError) {
            guard value < T.zero else {
                throw .init(message: "Number is not negative")
            }
        }
    }
}

extension AnyValidator where Value: Numeric & Comparable {
    public static var  isPositive: Self { .init(Validators.NumericAndComparable.IsPositive()) }
    public static var  isNegative: Self { .init(Validators.NumericAndComparable.IsNegative()) }
}
