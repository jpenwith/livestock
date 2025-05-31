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
        self.validators = validators
        self.wrappedValue = wrappedValue
        self.errors = validate(wrappedValue)
    }
    
    var wrappedValue: Value {
        didSet {
            self.errors = validate(wrappedValue)
        }
    }

    func validate(_ value: Value) -> [ValidationError] {
        var errors: [ValidationError] = []

        for validator in validators {
            do {
                try validator.validate(value)
            }
            catch {
                errors.append(error)
            }
        }

        return errors
    }
    
    var isValid: Bool { errors.isEmpty }

    var projectedValue: Self { self }
}

// Specialized version for optional values
@propertyWrapper struct OptionalValidated<Value> {
    let required: Required
    let validators: [AnyValidator<Value>]
    var errors: [ValidationError] = []

    init(wrappedValue: Value? = nil, _ required: Required, _ validators: AnyValidator<Value>...) {
        self.wrappedValue = wrappedValue
        self.required = required
        self.validators = validators
    }
    
    var wrappedValue: Value? {
        didSet {
            self.errors = validate(wrappedValue)
        }
    }
    
    func validate(_ value: Value?) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        if let value {
            for validator in validators {
                do {
                    try validator.validate(value)
                }
                catch {
                    errors.append(error)
                }
            }
        }
        else if required == .required {
            errors.append(.init(message: "Value is required"))
        }

        return errors
    }
    
    var isValid: Bool { errors.isEmpty }

    var projectedValue: Self { self }

    
    enum Required {
        case required
        case notRequired
    }
}
