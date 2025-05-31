import Foundation

/// A validator can check if a value conforms to specific rules.
public protocol Validator {
    associatedtype Value

    /// Validates the given value against this validator's rules.
    /// - Parameter value: The value to validate.
    /// - Returns: Boolean indicating if validation passed.
    func validate(_ value: Value) -> Bool

    /// An optional validation error message.
    var errorMessage: String { get }
}


struct AnyValidator<Value> {
    private let validate: (Value) -> Bool
    let errorMessage: String

    init<V: Validator>(_ validator: V) where V.Value == Value {
        validate = validator.validate
        errorMessage = validator.errorMessage
    }

    func validate(_ value: Value) -> Bool {
        validate(value)
    }
}
