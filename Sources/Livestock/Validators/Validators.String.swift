//
//  Validators.String.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

extension Validators {
    enum String {}
}

extension Validators.String {
    struct IsNotEmpty: Validator {
        func validate(_ value: String) throws(ValidationError) {
            guard !value.isEmpty else {
                throw .init(message: "Value is empty")
            }
        }
    }

    struct IsCountLessThan: Validator {
        let upperBound: Int

        func validate(_ value: String) throws(ValidationError) {
            guard value.count < upperBound else {
                throw .init(message: "\(value) is >= \(upperBound) characters")
            }
        }
    }

    struct IsCountGreaterThan: Validator {
        let lowerBound: Int

        func validate(_ value: String) throws(ValidationError) {
            guard value.count > lowerBound else {
                throw .init(message: "\(value) is <= \(lowerBound) characters")
            }
        }
    }

    struct IsCountBetween: Validator {
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

    struct IsCountLessThanOrEqualTo: Validator {
        let upperBound: Int

        func validate(_ value: String) throws(ValidationError) {
            guard value.count <= upperBound else {
                throw .init(message: "\(value) is > \(upperBound) characters")
            }
        }
    }

    struct IsCountGreaterThanOrEqualTo: Validator {
        let lowerBound: Int

        func validate(_ value: String) throws(ValidationError) {
            guard value.count >= lowerBound else {
                throw .init(message: "\(value) is < \(lowerBound) characters")
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
    
    struct IsAlphaNumeric: Validator {
        func validate(_ value: String) throws(ValidationError) {
            guard value.allSatisfy({ $0.isLetter || $0.isNumber }) else {
                throw .init(message: "Value contains non-alphanumeric characters")
            }
        }
    }
    
    struct IsEmailAddress: Validator {
        func validate(_ value: String) throws(ValidationError) {
            let emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,64}$/.ignoresCase()

            guard value.wholeMatch(of: emailRegex) != nil else {
                throw .init(message: "\(value) is not an email")
            }
        }
    }
}

extension AnyValidator where Value == String {
    static var  isNotEmpty: Self { .init(Validators.String.IsNotEmpty()) }
    static func isLessThan(_ upperBound: Int) -> Self { .init(Validators.String.IsCountLessThan(upperBound: upperBound)) }
    static func isGreaterThan(_ lowerBound: Int) -> Self { .init(Validators.String.IsCountGreaterThan(lowerBound: lowerBound)) }
    static func isBetween(_ lowerBound: Int, _ upperBound: Int) -> Self { .init(Validators.String.IsCountBetween(lowerBound: lowerBound, upperBound: upperBound)) }

    static func isLessThanOrEqualTo(_ upperBound: Int) -> Self { .init(Validators.String.IsCountLessThanOrEqualTo(upperBound: upperBound)) }
    static func isGreaterThanOrEqualTo(_ lowerBound: Int) -> Self { .init(Validators.String.IsCountGreaterThanOrEqualTo(lowerBound: lowerBound)) }
    static func matches(_ regex: Regex<Substring>) -> Self { .init(Validators.String.Matches(regex: regex)) }
    static var  isEmailAddress: Self { .init(Validators.String.IsEmailAddress()) }
    static func contains(_ substring: String, caseSensitive: Bool = true) -> Self { .init(Validators.String.Contains(substring: substring, caseSensitive: caseSensitive)) }
    static var  isAlphaNumeric: Self { .init(Validators.String.IsAlphaNumeric()) }
}
