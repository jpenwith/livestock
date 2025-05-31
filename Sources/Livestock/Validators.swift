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
        func validate(_ value: String) -> Bool {
            !value.isEmpty
        }
        
        var errorMessage: String {
            "Value is empty"
        }
    }

    struct CountLessThan: Validator {
        let upperBound: Int

        func validate(_ value: String) -> Bool {
            value.count < upperBound
        }
        
        var errorMessage: String {
            "Value is >= \(upperBound)"
        }
    }

    struct CountGreaterThan: Validator {
        let lowerBound: Int

        func validate(_ value: String) -> Bool {
            value.count > lowerBound
        }

        var errorMessage: String {
            "Value is <= \(lowerBound)"
        }
    }

    struct CountBetween: Validator {
        let lowerBound: Int
        let upperBound: Int

        func validate(_ value: String) -> Bool {
            value.count >= lowerBound && value.count <= upperBound
        }

        var errorMessage: String {
            "Value is < \(lowerBound) or > \(upperBound)"
        }
    }
}

extension AnyValidator where Value == String {
    static var notEmpty: Self { .init(Validators.String.NotEmpty()) }
    static func lessThan(_ upperBound: Int) -> Self { .init(Validators.String.CountLessThan(upperBound: upperBound)) }
    static func greaterThan(_ lowerBound: Int) -> Self { .init(Validators.String.CountGreaterThan(lowerBound: lowerBound)) }
    static func between(_ lowerBound: Int, _ upperBound: Int) -> Self { .init(Validators.String.CountBetween(lowerBound: lowerBound, upperBound: upperBound)) }
}
