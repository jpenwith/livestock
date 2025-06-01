//
//  Validators.Custom.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

extension Validators {
    public struct Custom<Value>: Validator {
        public let validator: (Value) throws(ValidationError) -> Void

        public init(validator: @escaping (Value) throws(ValidationError) -> Void) {
            self.validator = validator
        }
        
        public func validate(_ value: Value) throws(ValidationError) {
            try validator(value)
        }
    }
}

extension AnyValidator {
    public static func custom(validator: @escaping (Value) throws(ValidationError) -> Void) -> Self { .init(Validators.Custom(validator: validator)) }
}
