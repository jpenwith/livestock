//
//  Validators.Custom.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

extension Validators {
    struct Custom<Value>: Validator {
        let validator: (Value) throws(ValidationError) -> Void

        func validate(_ value: Value) throws(ValidationError) {
            try validator(value)
        }
    }
}

extension AnyValidator {
    static func custom(validator: @escaping (Value) throws(ValidationError) -> Void) -> Self { .init(Validators.Custom(validator: validator)) }
}
