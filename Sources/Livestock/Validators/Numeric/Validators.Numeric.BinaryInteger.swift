//
//  Validators.Numeric.BinaryInteger.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//



extension Validators.Numeric {
    public enum BinaryInteger {}
}
    
extension Validators.Numeric.BinaryInteger {
    public struct IsMultipleOf<T: BinaryInteger>: Validator {
        public let divisor: T
        
        public init(divisor: T) {
            self.divisor = divisor
        }
        
        public func validate(_ value: T) throws(ValidationError) {
            guard value % divisor == 0 else {
                throw .init(message: "Value is not a multiple of \(divisor)")
            }
        }
    }

    public struct IsEven<T: BinaryInteger>: Validator {
        public func validate(_ value: T) throws(ValidationError) {
            guard value % 2 == 0 else {
                throw .init(message: "Value is not even")
            }
        }
    }
    
    public struct IsOdd<T: BinaryInteger>: Validator {
        public func validate(_ value: T) throws(ValidationError) {
            guard value % 2 != 0 else {
                throw .init(message: "Value is not odd")
            }
        }
    }
}

extension AnyValidator where Value: BinaryInteger {
    public static func isMultipleOf(_ divisor: Value) -> Self { .init(Validators.Numeric.BinaryInteger.IsMultipleOf(divisor: divisor)) }
    public static var isEven: Self { .init(Validators.Numeric.BinaryInteger.IsEven()) }
    public static var isOdd: Self { .init(Validators.Numeric.BinaryInteger.IsOdd()) }
}
