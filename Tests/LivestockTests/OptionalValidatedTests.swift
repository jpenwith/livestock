import Testing
@testable import Livestock
import Foundation

@Suite("OptionalValidated Tests")
struct OptionalValidatedTests {
    
    // MARK: - Required Validation
    
    @Test("OptionalValidated fails when required value is nil")
    func requiredValidationFailsForNilValue() throws {
        @OptionalValidated(.required, .isNotEmpty)
        var requiredString: String?
        
        #expect(!$requiredString.isValid)
        #expect($requiredString.errors.count == 1)
        #expect($requiredString.errors.first?.message == "Value is required")
    }
    
    @Test("OptionalValidated passes when required value is not nil")
    func requiredValidationPassesForNonNilValue() throws {
        @OptionalValidated(.required, .isNotEmpty)
        var requiredString: String? = "Hello"
        
        #expect($requiredString.isValid)
    }
    
    // MARK: - Not Required Validation
    
    @Test("OptionalValidated passes when not required value is nil")
    func notRequiredValidationPassesForNilValue() throws {
        @OptionalValidated(.notRequired, .isNotEmpty)
        var optionalString: String?
        
        #expect($optionalString.isValid)
    }
    
    // MARK: - Validator Application
    
    @Test("OptionalValidated applies validators when value is not nil")
    func validatorsAppliedToNonNilValue() throws {
        @OptionalValidated(.required, .isNotEmpty)
        var validString: String? = "Hello"
        
        #expect($validString.isValid)
        
        @OptionalValidated(.required, .isNotEmpty)
        var invalidString: String? = ""
        
        #expect(!$invalidString.isValid)
        #expect($invalidString.errors.count == 1)
        #expect($invalidString.errors.first?.message == "Value is empty")
    }
    
    @Test("OptionalValidated with multiple validators")
    func multipleValidatorsApplied() throws {
        @OptionalValidated(.required, .isNotEmpty, .isLessThan(10))
        var validString: String? = "Hello"
        
        #expect($validString.isValid)
        
        @OptionalValidated(.required, .isNotEmpty, .isLessThan(4))
        var invalidString: String? = "Hello"
        
        #expect(!$invalidString.isValid)
        #expect($invalidString.errors.count == 1)
        #expect($invalidString.errors.first?.message == "Hello is >= 4 characters")
    }
    
    // MARK: - Value Updates
    
    @Test("OptionalValidated validation updates when value changes")
    func validationUpdatesWithValueChanges() throws {
        @OptionalValidated(.required, .isNotEmpty)
        var testString: String? = "Hello"
        
        #expect($testString.isValid)
        
        testString = ""
        #expect(!$testString.isValid)
        #expect($testString.errors.count == 1)
        
        testString = nil
        #expect(!$testString.isValid)
        #expect($testString.errors.count == 1)
        #expect($testString.errors.first?.message == "Value is required")
        
        testString = "Valid again"
        #expect($testString.isValid)
    }
    
    // MARK: - Complex Type Tests
    
    @Test("OptionalValidated with collection types")
    func validationWorksWithCollectionTypes() throws {
        @OptionalValidated(.required, .isNotEmpty)
        var optionalArray: [Int]? = [1, 2, 3]
        
        #expect($optionalArray.isValid)
        
        optionalArray = []
        #expect(!$optionalArray.isValid)
        #expect($optionalArray.errors.count == 1)
        #expect($optionalArray.errors.first?.message == "Collection is empty")
        
        optionalArray = nil
        #expect(!$optionalArray.isValid)
    }
    
    @Test("OptionalValidated with Comparable types")
    func validationWorksWithComparableTypes() throws {
        @OptionalValidated(.required, .isGreaterThan(5))
        var optionalInt: Int? = 10
        
        #expect($optionalInt.isValid)
        
        optionalInt = 3
        #expect(!$optionalInt.isValid)
        #expect($optionalInt.errors.count == 1)
        #expect($optionalInt.errors.first?.message == "Value is not greater than 5")
    }
    
    @Test("OptionalValidated with custom types")
    func validationWorksWithCustomTypes() throws {
        struct Person {
            let name: String
            let age: Int
        }
        
        let personValidator = { (person: Person) throws(ValidationError) in
            if person.age < 18 {
                throw ValidationError(message: "Person must be an adult")
            }
        }
        
        @OptionalValidated(.required, .custom(validator: personValidator))
        var optionalPerson: Person? = Person(name: "John", age: 25)
        
        #expect($optionalPerson.isValid)
        
        optionalPerson = Person(name: "Child", age: 10)
        #expect(!$optionalPerson.isValid)
        #expect($optionalPerson.errors.count == 1)
        #expect($optionalPerson.errors.first?.message == "Person must be an adult")
    }
}
