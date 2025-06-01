//
//  Validated.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

@propertyWrapper public struct Validated<Value> {
    public let validators: [AnyValidator<Value>]

    public var errors: [ValidationError] = []

    public init(wrappedValue: Value, _ validators: AnyValidator<Value>...) {
        self.init(wrappedValue: wrappedValue, validators)
    }
    
    public init(wrappedValue: Value, _ validators: [AnyValidator<Value>]) {
        self.wrappedValue = wrappedValue
        self.validators = validators

        self.errors = validate(wrappedValue)
    }
    
    public var wrappedValue: Value {
        didSet { self.errors = validate(wrappedValue) }
    }

    public func validate(_ value: Value) -> [ValidationError] {
        validators.validate(value)
    }

    public var isValid: Bool { errors.isEmpty }

    public var projectedValue: Self { self }
}

@propertyWrapper public struct OptionalValidated<Value> {
    public let required: Required
    public let validators: [AnyValidator<Value>]
    
    public var errors: [ValidationError] = []
    
    public init(wrappedValue: Value? = nil, _ required: Required, _ validators: AnyValidator<Value>...) {
        self.init(wrappedValue: wrappedValue, required, validators)
    }
    
    public init(wrappedValue: Value? = nil, _ required: Required, _ validators: [AnyValidator<Value>]) {
        self.wrappedValue = wrappedValue
        self.required = required
        self.validators = validators
        
        self.errors = validate(wrappedValue)
    }
    
    public var wrappedValue: Value? {
        didSet { self.errors = validate(wrappedValue) }
    }

    public func validate(_ value: Value?) -> [ValidationError] {
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
    
    public var isValid: Bool { errors.isEmpty }
    
    public var projectedValue: Self { self }
}

extension OptionalValidated {
    public enum Required {
        case required
        case notRequired
    }
}
