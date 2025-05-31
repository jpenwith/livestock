//
//  Validated.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

@propertyWrapper struct Validated<Value> {
    let validators: [AnyValidator<Value>]
    var wrappedValue: Value

    init(wrappedValue: Value, _ validators: AnyValidator<Value>...) {
        self.validators = validators
        self.wrappedValue = wrappedValue
    }
}
