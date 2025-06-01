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
    public struct IsNotEmpty<T: Collection>: Validator {
        public func validate(_ value: T) throws(ValidationError) {
            guard !value.isEmpty else {
                throw .init(message: "Collection is empty")
            }
        }
    }
    
    public struct IsCountLessThan<T: Collection>: Validator {
        public let upperBound: Int
        
        public init(upperBound: Int) {
            self.upperBound = upperBound
        }
        
        public func validate(_ value: T) throws(ValidationError) {
            guard value.count < upperBound else {
                throw .init(message: "Collection count \(value.count) is >= \(upperBound)")
            }
        }
    }
    
    public struct IsCountGreaterThan<T: Collection>: Validator {
        public let lowerBound: Int
        
        public init(lowerBound: Int) {
            self.lowerBound = lowerBound
        }

        public func validate(_ value: T) throws(ValidationError) {
            guard value.count > lowerBound else {
                throw .init(message: "Collection count \(value.count) is <= \(lowerBound)")
            }
        }
    }
    
    public struct IsCountBetween<T: Collection>: Validator {
        public let lowerBound: Int
        public let upperBound: Int
        
        public init(lowerBound: Int, upperBound: Int) {
            self.lowerBound = lowerBound
            self.upperBound = upperBound
        }
        
        public func validate(_ value: T) throws(ValidationError) {
            guard value.count >= lowerBound else {
                throw .init(message: "Collection count \(value.count) is < \(lowerBound)")
            }
            
            guard value.count <= upperBound else {
                throw .init(message: "Collection count \(value.count) is > \(upperBound)")
            }
        }
    }
    
    public struct ContainsElement<T: Collection>: Validator where T.Element: Equatable {
        public let element: T.Element
        
        public init(element: T.Element) {
            self.element = element
        }

        public func validate(_ value: T) throws(ValidationError) {
            guard value.contains(element) else {
                throw .init(message: "Collection does not contain required element")
            }
        }
    }
    
    public struct AllElementsPass<T: Collection>: Validator {
        public let elementValidator: (T.Element) throws(ValidationError) -> Void
        
        public init(elementValidator: @escaping (T.Element) throws(ValidationError) -> Void) {
            self.elementValidator = elementValidator
        }
        
        public func validate(_ value: T) throws(ValidationError) {
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
    public static var  isNotEmpty: Self { .init(Validators.Collection.IsNotEmpty()) }
    public static func isLessThan(_ upperBound: Int) -> Self { .init(Validators.Collection.IsCountLessThan(upperBound: upperBound)) }
    public static func isGreaterThan(_ lowerBound: Int) -> Self { .init(Validators.Collection.IsCountGreaterThan(lowerBound: lowerBound)) }
    public static func isBetween(_ lowerBound: Int, _ upperBound: Int) -> Self { .init(Validators.Collection.IsCountBetween(lowerBound: lowerBound, upperBound: upperBound)) }
    public static func allPass(_ validator: @escaping (Value.Element) throws(ValidationError) -> Void) -> Self {
        .init(Validators.Collection.AllElementsPass(elementValidator: validator))
    }
}

extension AnyValidator where Value: Collection, Value.Element: Equatable {
    public static func contains(_ element: Value.Element) -> Self {
        .init(Validators.Collection.ContainsElement(element: element))
    }
}
