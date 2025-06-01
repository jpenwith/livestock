//
//  Validators.NumericAndComparable.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

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
