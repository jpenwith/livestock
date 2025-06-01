//
//  Validators.Numeric.BinaryInteger.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//



extension Validators.Numeric {
    enum BinaryInteger {}
}
    
extension Validators.Numeric.BinaryInteger {
    struct IsMultipleOf<T: BinaryInteger>: Validator {
        let divisor: T
        
        func validate(_ value: T) throws(ValidationError) {
            guard value % divisor == 0 else {
                throw .init(message: "Value is not a multiple of \(divisor)")
            }
        }
    }

    struct IsEven<T: BinaryInteger>: Validator {
        func validate(_ value: T) throws(ValidationError) {
            guard value % 2 == 0 else {
                throw .init(message: "Value is not even")
            }
        }
    }
    
    struct IsOdd<T: BinaryInteger>: Validator {
        func validate(_ value: T) throws(ValidationError) {
            guard value % 2 != 0 else {
                throw .init(message: "Value is not odd")
            }
        }
    }
}

extension AnyValidator where Value: BinaryInteger {
    static func isMultipleOf(_ divisor: Value) -> Self { .init(Validators.Numeric.BinaryInteger.IsMultipleOf(divisor: divisor)) }
    static var isEven: Self { .init(Validators.Numeric.BinaryInteger.IsEven()) }
    static var isOdd: Self { .init(Validators.Numeric.BinaryInteger.IsOdd()) }
}
