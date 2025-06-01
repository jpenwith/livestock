//
//  Validators.Collection.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//

extension Validators {
    enum Collection {}
}

extension Validators.Collection {
    struct IsNotEmpty<T: Collection>: Validator {
        func validate(_ value: T) throws(ValidationError) {
            guard !value.isEmpty else {
                throw .init(message: "Collection is empty")
            }
        }
    }
    
    struct IsCountLessThan<T: Collection>: Validator {
        let upperBound: Int
        
        func validate(_ value: T) throws(ValidationError) {
            guard value.count < upperBound else {
                throw .init(message: "Collection count \(value.count) is >= \(upperBound)")
            }
        }
    }
    
    struct IsCountGreaterThan<T: Collection>: Validator {
        let lowerBound: Int
        
        func validate(_ value: T) throws(ValidationError) {
            guard value.count > lowerBound else {
                throw .init(message: "Collection count \(value.count) is <= \(lowerBound)")
            }
        }
    }
    
    struct IsCountBetween<T: Collection>: Validator {
        let lowerBound: Int
        let upperBound: Int
        
        func validate(_ value: T) throws(ValidationError) {
            guard value.count >= lowerBound else {
                throw .init(message: "Collection count \(value.count) is < \(lowerBound)")
            }
            
            guard value.count <= upperBound else {
                throw .init(message: "Collection count \(value.count) is > \(upperBound)")
            }
        }
    }
    
    struct ContainsElement<T: Collection>: Validator where T.Element: Equatable {
        let element: T.Element

        func validate(_ value: T) throws(ValidationError) {
            guard value.contains(element) else {
                throw .init(message: "Collection does not contain required element")
            }
        }
    }
    
    struct AllElementsPass<T: Collection>: Validator {
        let elementValidator: (T.Element) throws(ValidationError) -> Void
        
        func validate(_ value: T) throws(ValidationError) {
            for element in value {
                do {
                    try elementValidator(element)
                }
                catch {
                    throw .init(message: "Element validation failed: \(error.message)")
                }
            }
        }
    }
}

extension AnyValidator where Value: Collection {
    static var  isNotEmpty: Self { .init(Validators.Collection.IsNotEmpty()) }
    static func isLessThan(_ upperBound: Int) -> Self { .init(Validators.Collection.IsCountLessThan(upperBound: upperBound)) }
    static func isGreaterThan(_ lowerBound: Int) -> Self { .init(Validators.Collection.IsCountGreaterThan(lowerBound: lowerBound)) }
    static func isBetween(_ lowerBound: Int, _ upperBound: Int) -> Self { .init(Validators.Collection.IsCountBetween(lowerBound: lowerBound, upperBound: upperBound)) }
    static func allPass(_ validator: @escaping (Value.Element) throws(ValidationError) -> Void) -> Self {
        .init(Validators.Collection.AllElementsPass(elementValidator: validator))
    }
}

extension AnyValidator where Value: Collection, Value.Element: Equatable {
    static func contains(_ element: Value.Element) -> Self {
        .init(Validators.Collection.ContainsElement(element: element))
    }
}
