import Foundation

public protocol Validator {
    associatedtype Value

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

    public func validate(_ value: Value) throws(ValidationError) {
        try validate(value)
    }
}

extension Array {
    func validate<Value>(_ value: Value) -> [ValidationError] where Element == AnyValidator<Value> {
        compactMap { (validator) -> ValidationError? in
            do {
                try validator.validate(value)
            }
            catch let error as ValidationError {
                return error
            }
            catch {
                return nil
            }

            return nil
        }
    }
}
