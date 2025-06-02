//
//  Validators.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//
import Foundation


public enum Validators {}

extension Validators {
    public struct Multiple<Value>: Validator {
        public let validators: [AnyValidator<Value>]

        public init(validators: [AnyValidator<Value>]) {
            self.validators = validators
        }

        public func validate(_ value: Value) throws(ValidationError) {
            for validator in validators {
                try validator.validate(value)
            }
        }
    }
}

extension AnyValidator {
    public static func multiple(_ validators: [AnyValidator<Value>]) -> Self { .init(Validators.Multiple(validators: validators)) }
}
