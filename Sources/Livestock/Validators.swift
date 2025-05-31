//
//  Validators.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

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
                throw .init(message: "\(value) is >= \(upperBound)")
            }
        }
    }

    struct CountGreaterThan: Validator {
        let lowerBound: Int

        func validate(_ value: String) throws(ValidationError) {
            guard value.count > lowerBound else {
                throw .init(message: "\(value) is <= \(lowerBound)")
            }
        }
    }

    struct CountBetween: Validator {
        let lowerBound: Int
        let upperBound: Int

        func validate(_ value: String) throws(ValidationError) {
            guard value.count >= lowerBound else {
                throw .init(message: "\(value) is < \(lowerBound)")
            }
                    
            guard value.count <= upperBound else {
                throw .init(message: "\(value) is > \(upperBound)")
            }
        }
    }
}

extension AnyValidator where Value == String {
    static var notEmpty: Self { .init(Validators.String.NotEmpty()) }
    static func lessThan(_ upperBound: Int) -> Self { .init(Validators.String.CountLessThan(upperBound: upperBound)) }
    static func greaterThan(_ lowerBound: Int) -> Self { .init(Validators.String.CountGreaterThan(lowerBound: lowerBound)) }
    static func between(_ lowerBound: Int, _ upperBound: Int) -> Self { .init(Validators.String.CountBetween(lowerBound: lowerBound, upperBound: upperBound)) }
}
