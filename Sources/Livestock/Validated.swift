//
//  Validated.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

@propertyWrapper struct Validated<Value> {
    let validators: [AnyValidator<Value>]

    var errors: [ValidationError] = []

    init(wrappedValue: Value, _ validators: AnyValidator<Value>...) {
        self.init(wrappedValue: wrappedValue, validators)
    }
    
    init(wrappedValue: Value, _ validators: [AnyValidator<Value>]) {
        self.wrappedValue = wrappedValue
        self.validators = validators

        self.errors = validate(wrappedValue)
    }
    
    var wrappedValue: Value {
        didSet { self.errors = validate(wrappedValue) }
    }

    func validate(_ value: Value) -> [ValidationError] {
        validators.validate(value)
    }

    var isValid: Bool { errors.isEmpty }

    var projectedValue: Self { self }
}

@propertyWrapper struct OptionalValidated<Value> {
    let required: Required
    
    let validators: [AnyValidator<Value>]
    
    var errors: [ValidationError] = []
    
    init(wrappedValue: Value? = nil, _ required: Required, _ validators: AnyValidator<Value>...) {
        self.init(wrappedValue: wrappedValue, required, validators)
    }
    
    init(wrappedValue: Value? = nil, _ required: Required, _ validators: [AnyValidator<Value>]) {
        self.wrappedValue = wrappedValue
        self.required = required
        self.validators = validators
        
        self.errors = validate(wrappedValue)
    }
    
    var wrappedValue: Value? {
        didSet { self.errors = validate(wrappedValue) }
    }

    func validate(_ value: Value?) -> [ValidationError] {
        if let value {
            return validators.validate(value)
        }
        else {
            if required == .required {
                return [.init(message: "Value is required")]
            }
            else {
                return []
            }
        }
    }
    
    var isValid: Bool { errors.isEmpty }
    
    var projectedValue: Self { self }
}

extension OptionalValidated {
    enum Required {
        case required
        case notRequired
    }
}
