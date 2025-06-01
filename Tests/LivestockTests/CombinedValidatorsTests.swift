import Testing
@testable import Livestock
import Foundation

@Suite("Combined Validators Tests")
struct CombinedValidatorsTests {
    @Test("String with multiple validators - all passing")
    func stringWithMultipleValidatorsAllPassing() throws {
        @Validated(.isNotEmpty, .isLessThan(12), .isEmailAddress)
        var email = "hi@test.com"

        #expect($email.isValid)
        #expect($email.errors.isEmpty)
    }

    @Test("String with multiple validators - one failing")
    func stringWithMultipleValidatorsOneFailing() throws {
        @Validated(.isNotEmpty, .isLessThan(10), .isEmailAddress)
        var invalidEmail = "not-an-email"

        #expect(!$invalidEmail.isValid)
        #expect($invalidEmail.errors.count == 2)
        
        #expect($invalidEmail.errors.first?.message.contains("is >= 10") ?? false)
    }

    @Test("String with multiple validators - multiple failing")
    func stringWithMultipleValidatorsMultipleFailing() throws {
        @Validated(.isNotEmpty, .isLessThan(10), .isEmailAddress)
        var invalidEmail = "this.is.too.long@example.c"

        #expect(!$invalidEmail.isValid)
        // Validations should fail for both length and email format
        #expect($invalidEmail.errors.count == 2)
    }

    // MARK: - Mixed Type Validators

    @Test("Model with different property validators")
    func modelWithDifferentPropertyValidators() throws {
        struct User {
            @Validated(.isNotEmpty, .isLessThan(50))
            var name: String = ""

            @Validated(.isEmailAddress)
            var email: String = ""

            @Validated(.isGreaterThan(0), .isLessThan(120))
            var age: Int = 0

            var isValid: Bool {
                return $name.isValid && $email.isValid && $age.isValid
            }
        }

        var user = User()
        user.name = "John Doe"
        user.email = "john@example.com"
        user.age = 30

        #expect(user.isValid)
    }

    // MARK: - Collection Validators Combined with Element Validators

    @Test("Array with both collection and element validators")
    func arrayWithBothCollectionAndElementValidators() throws {
        let positiveNumber = { (value: Int) throws(ValidationError) in
            if value <= 0 {
                throw ValidationError(message: "Number must be positive")
            }
        }

        @Validated(.isNotEmpty, .isLessThan(5), .allPass(positiveNumber))
        var numbers = [1, 2, 3]

        #expect($numbers.isValid)

        numbers = []
        #expect(!$numbers.isValid)
        #expect($numbers.errors.count == 1)
        #expect($numbers.errors.first?.message == "Collection is empty")

        numbers = [1, 2, 3, 4, 5]
        #expect(!$numbers.isValid)
        #expect($numbers.errors.count == 1)
        #expect($numbers.errors.first?.message.contains("Collection count 5 is >= 5") ?? false)

        numbers = [1, 2, -3]
        #expect(!$numbers.isValid)
        #expect($numbers.errors.count == 1)
        #expect($numbers.errors.first?.message.contains("Element validation failed") ?? false)
    }

    // MARK: - Numeric & Comparable Combined

    @Test("Integer with multiple validators")
    func integerWithMultipleValidators() throws {
        @Validated(.isPositive, .isGreaterThan(10), .isMultipleOf(2))
        var number = 12

        #expect($number.isValid)

        number = 11
        #expect(!$number.isValid)
        #expect($number.errors.count == 1)
        #expect($number.errors.first?.message == "Value is not a multiple of 2")

        number = 8
        #expect(!$number.isValid)
        #expect($number.errors.count == 1)
        #expect($number.errors.first?.message == "Value is not greater than 10")

        number = -2
        #expect(!$number.isValid)
        #expect($number.errors.count == 2)
        #expect($number.errors.first?.message == "Number is not positive")
    }

    // MARK: - Date Combined Validators

    @Test("Date with multiple validators")
    func dateWithMultipleValidators() throws {
        let now = Date()
        let pastDate = now.addingTimeInterval(-86400 * 7) // One week ago
        let futureDate = now.addingTimeInterval(86400 * 7) // One week in future

        @Validated(.isInTheFuture, .isBefore(futureDate))
        var date = now.addingTimeInterval(86400) // Tomorrow

        #expect($date.isValid)

        date = pastDate
        #expect(!$date.isValid)
        #expect($date.errors.count == 1)
        #expect($date.errors.first?.message == "Date is not in the future")

        date = futureDate.addingTimeInterval(86400) // Beyond one week
        #expect(!$date.isValid)
        #expect($date.errors.count == 1)
        #expect($date.errors.first?.message.contains("Date is not before") ?? false)
    }

    // MARK: - Custom Validator with Standard Validators

    @Test("Custom validator combined with standard validators")
    func customValidatorWithStandardValidators() throws {
        @Validated(.isNotEmpty, .isEmailAddress, .custom(validator: { (value: String) throws(ValidationError) in
            guard value.hasSuffix("@company.com") else {
                throw ValidationError(message: "Email must use company domain")
            }
        }))

        var email = "user@company.com"
        #expect($email.isValid)

        email = "user@gmail.com"
        #expect(!$email.isValid)
        #expect($email.errors.count == 1)
        #expect($email.errors.first?.message == "Email must use company domain")

        email = "not-an-email"
        #expect(!$email.isValid)
        #expect($email.errors.count == 2)
        #expect($email.errors.first?.message.contains("is not an email") ?? false)
    }
}
