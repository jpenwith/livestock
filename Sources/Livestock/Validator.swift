import Foundation

/// A validator can check if a value conforms to specific rules.
public protocol Validator {
    associatedtype Value

    /// Validates the given value against this validator's rules.
    /// - Parameter value: The value to validate.
    /// - Returns: Boolean indicating if validation passed.
    func validate(_ value: Value) throws(ValidationError)
}


public struct ValidationError: Error {
    public let message: String
    
    public init(message: String) {
        self.message = message
    }
}

public struct AnyValidator<Value> {
    private let validate: (Value) throws(ValidationError) -> Void

    public init<V: Validator>(_ validator: V) where V.Value == Value {
        validate = validator.validate
    }

    func validate(_ value: Value) throws(ValidationError) {
        try validate(value)
    }
}
