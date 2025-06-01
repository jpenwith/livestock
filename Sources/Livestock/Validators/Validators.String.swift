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
    public struct IsNotEmpty: Validator {
        public func validate(_ value: String) throws(ValidationError) {
            guard !value.isEmpty else {
                throw .init(message: "Value is empty")
            }
        }
    }

    public struct IsCountLessThan: Validator {
        public let upperBound: Int

        public init(upperBound: Int) {
            self.upperBound = upperBound
        }
        
        public func validate(_ value: String) throws(ValidationError) {
            guard value.count < upperBound else {
                throw .init(message: "\(value) is >= \(upperBound) characters")
            }
        }
    }

    public struct IsCountLessThanOrEqualTo: Validator {
        public let upperBound: Int
        
        public init(upperBound: Int) {
            self.upperBound = upperBound
        }

        public func validate(_ value: String) throws(ValidationError) {
            guard value.count <= upperBound else {
                throw .init(message: "\(value) is > \(upperBound) characters")
            }
        }
    }

    public struct IsCountGreaterThan: Validator {
        public let lowerBound: Int

        public init(lowerBound: Int) {
            self.lowerBound = lowerBound
        }
        
        public func validate(_ value: String) throws(ValidationError) {
            guard value.count > lowerBound else {
                throw .init(message: "\(value) is <= \(lowerBound) characters")
            }
        }
    }

    public struct IsCountGreaterThanOrEqualTo: Validator {
        public let lowerBound: Int
        
        public init(lowerBound: Int) {
            self.lowerBound = lowerBound
        }

        public func validate(_ value: String) throws(ValidationError) {
            guard value.count >= lowerBound else {
                throw .init(message: "\(value) is < \(lowerBound) characters")
            }
        }
    }
    
    public struct IsCountBetween: Validator {
        public let lowerBound: Int
        public let upperBound: Int

        public init(lowerBound: Int, upperBound: Int) {
            self.lowerBound = lowerBound
            self.upperBound = upperBound
        }
        
        public func validate(_ value: String) throws(ValidationError) {
            guard value.count >= lowerBound else {
                throw .init(message: "\(value) is < \(lowerBound) characters")
            }
                    
            guard value.count <= upperBound else {
                throw .init(message: "\(value) is > \(upperBound) characters")
            }
        }
    }

    public struct Matches: Validator {
        public let regex: Regex<Substring>
        
        public init(regex: Regex<Substring>) {
            self.regex = regex
        }
        
        public func validate(_ value: String) throws(ValidationError) {
            guard value.wholeMatch(of: regex) != nil else {
                throw .init(message: "\(value) does not match \(regex)")
            }
        }
    }

    public struct Contains: Validator {
        public let substring: String
        public let caseSensitive: Bool
        
        public init(substring: String, caseSensitive: Bool = true) {
            self.substring = substring
            self.caseSensitive = caseSensitive
        }
        
        public func validate(_ value: String) throws(ValidationError) {
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
    
    public struct IsAlphaNumeric: Validator {
        public func validate(_ value: String) throws(ValidationError) {
            guard value.allSatisfy({ $0.isLetter || $0.isNumber }) else {
                throw .init(message: "Value contains non-alphanumeric characters")
            }
        }
    }
    
    public struct IsEmailAddress: Validator {
        public func validate(_ value: String) throws(ValidationError) {
            let emailRegex = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,64}$/.ignoresCase()

            guard value.wholeMatch(of: emailRegex) != nil else {
                throw .init(message: "\(value) is not an email")
            }
        }
    }
}

extension AnyValidator where Value == String {
    public static var  isNotEmpty: Self { .init(Validators.String.IsNotEmpty()) }
    public static func isLessThan(_ upperBound: Int) -> Self { .init(Validators.String.IsCountLessThan(upperBound: upperBound)) }
    public static func isLessThanOrEqualTo(_ upperBound: Int) -> Self { .init(Validators.String.IsCountLessThanOrEqualTo(upperBound: upperBound)) }
    public static func isGreaterThan(_ lowerBound: Int) -> Self { .init(Validators.String.IsCountGreaterThan(lowerBound: lowerBound)) }
    public static func isGreaterThanOrEqualTo(_ lowerBound: Int) -> Self { .init(Validators.String.IsCountGreaterThanOrEqualTo(lowerBound: lowerBound)) }
    public static func isBetween(_ lowerBound: Int, _ upperBound: Int) -> Self { .init(Validators.String.IsCountBetween(lowerBound: lowerBound, upperBound: upperBound)) }
    public static func matches(_ regex: Regex<Substring>) -> Self { .init(Validators.String.Matches(regex: regex)) }
    public static var  isEmailAddress: Self { .init(Validators.String.IsEmailAddress()) }
    public static func contains(_ substring: String, caseSensitive: Bool = true) -> Self { .init(Validators.String.Contains(substring: substring, caseSensitive: caseSensitive)) }
    public static var  isAlphaNumeric: Self { .init(Validators.String.IsAlphaNumeric()) }
}
