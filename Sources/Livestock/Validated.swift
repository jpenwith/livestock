//
//  Validated.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

@propertyWrapper struct Validated<Value> {
    var wrappedValue: Value
    let validators: [AnyValidator<Value>]

    init(wrappedValue: Value, _ validators: AnyValidator<Value>...) {
        self.validators = validators
        self.wrappedValue = wrappedValue
    }
}

// Specialized version for optional values
@propertyWrapper struct OptionalValidated<Value> {
    var wrappedValue: Value?
    let required: Required
    let validators: [AnyValidator<Value>]

    init(wrappedValue: Value? = nil, _ required: Required = .notRequired, _ validators: AnyValidator<Value>...) {
        self.wrappedValue = wrappedValue
        self.required = required
        self.validators = validators
    }
    
    enum Required {
        case required
        case notRequired
    }
}

// Type alias to make usage cleaner
//typealias Validated_Optional<Value> = ValidatedOptional<Value>
//
//// Extension to allow using normal validators with optional values
//extension AnyValidator {
//    func optional(allowNil: Bool = true) -> AnyValidator<Value?> {
//        .init(OptionalValidator<Value>(allowNil: allowNil, message: self.errorMessage) { value in
//            self.validate(value)
//        })
//    }
//}
