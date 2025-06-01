import Testing
@testable import Livestock
import Foundation

@Suite("String Validators")
struct StringValidatorsTests {
    
    // MARK: - notEmpty
    
    @Test("String.notEmpty validator passes for non-empty string")
    func notEmptyPassesForNonEmptyString() throws {
        @Validated(.isNotEmpty)
        var validValue = "Hello"
        
        #expect($validValue.isValid)
    }
    
    @Test("String.notEmpty validator fails for empty string")
    func notEmptyFailsForEmptyString() throws {
        @Validated(.isNotEmpty)
        var invalidValue = ""
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Value is empty")
    }
    
    // MARK: - lessThan
    
    @Test("String.lessThan validator passes for strings with length less than bound")
    func lessThanPassesForValidLength() throws {
        @Validated(.isLessThan(5))
        var validValue = "Test"
        
        #expect($validValue.isValid)
    }
    
    @Test("String.lessThan validator fails for strings with length equal to bound")
    func lessThanFailsForEqualLength() throws {
        @Validated(.isLessThan(5))
        var invalidValue = "Hello"
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Hello is >= 5 characters")
    }
    
    @Test("String.lessThan validator fails for strings with length greater than bound")
    func lessThanFailsForGreaterLength() throws {
        @Validated(.isLessThan(5))
        var invalidValue = "Testing"
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Testing is >= 5 characters")
    }
    
    // MARK: - lessThanOrEqualTo
    @Test("String.lessThanOrEqualTo validator passes for strings with length equal to bound")
    func lessThanOrEqualToPassesForEqualLength() throws {
        @Validated(.isLessThanOrEqualTo(5))
        var validValue = "Hello"

        #expect($validValue.isValid)
    }

    @Test("String.lessThanOrEqualTo validator fails for strings with length greater than bound")
    func lessThanOrEqualToFailsForGreaterLength() throws {
        @Validated(.isLessThanOrEqualTo(5))
        var invalidValue = "Testing"

        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Testing is > 5 characters")
    }

    // MARK: - greaterThan
    
    @Test("String.greaterThan validator passes for strings with length greater than bound")
    func greaterThanPassesForValidLength() throws {
        @Validated(.isGreaterThan(3))
        var validValue = "Test"
        
        #expect($validValue.isValid)
    }
    
    @Test("String.greaterThan validator fails for strings with length equal to bound")
    func greaterThanFailsForEqualLength() throws {
        @Validated(.isGreaterThan(4))
        var invalidValue = "Test"
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Test is <= 4 characters")
    }
    
    @Test("String.greaterThan validator fails for strings with length less than bound")
    func greaterThanFailsForLessLength() throws {
        @Validated(.isGreaterThan(5))
        var invalidValue = "Test"
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Test is <= 5 characters")
    }
    
    // MARK: - greaterThanOrEqualTo
    @Test("String.greaterThanOrEqualTo validator passes for strings with length greater than or equal to bound")
    func greaterThanOrEqualToPassesForValuesAtOrAboveBound() throws {
        @Validated(.isGreaterThanOrEqualTo(4))
        var validValue1 = "Test"

        #expect($validValue1.isValid)

        @Validated(.isGreaterThanOrEqualTo(4))
        var validValue2 = "Testing"

        #expect($validValue2.isValid)
    }

    @Test("String.greaterThanOrEqualTo validator fails for strings with length less than bound")
    func greaterThanOrEqualToFailsForLessLength() throws {
        @Validated(.isGreaterThanOrEqualTo(5))
        var invalidValue = "Test"

        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Test is < 5 characters")
    }

    // MARK: - between
    
    @Test("String.between validator passes for strings with length within bounds")
    func betweenPassesForValidLength() throws {
        @Validated(.isBetween(3, 5))
        var validValue1 = "Hi!"
        
        #expect($validValue1.isValid)
        
        @Validated(.isBetween(3, 5))
        var validValue2 = "Hello"
        
        #expect($validValue2.isValid)
    }
    
    @Test("String.between validator fails for strings with length less than lower bound")
    func betweenFailsForLessThanLowerBound() throws {
        @Validated(.isBetween(3, 5))
        var invalidValue = "Hi"
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Hi is < 3 characters")
    }
    
    @Test("String.between validator fails for strings with length greater than upper bound")
    func betweenFailsForGreaterThanUpperBound() throws {
        @Validated(.isBetween(3, 5))
        var invalidValue = "Testing"
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Testing is > 5 characters")
    }
    
    // MARK: - matches
    
    @Test("String.matches validator passes for strings matching regex")
    func matchesPassesForMatchingString() throws {
        let digitRegex = /\d+/
        
        @Validated(.matches(digitRegex))
        var validValue = "12345"
        
        #expect($validValue.isValid)
    }
    
    @Test("String.matches validator fails for strings not matching regex")
    func matchesFailsForNonMatchingString() throws {
        let digitRegex = /\d+/
        
        @Validated(.matches(digitRegex))
        var invalidValue = "abc"
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message.contains("does not match") ?? false)
    }
    
    // MARK: - email
    
    @Test("String.email validator passes for valid email addresses")
    func emailPassesForValidEmails() throws {
        @Validated(.isEmailAddress)
        var validValue1 = "test@example.com"
        
        #expect($validValue1.isValid)
        
        @Validated(.isEmailAddress)
        var validValue2 = "user.name+tag@domain.co.uk"
        
        #expect($validValue2.isValid)
    }
    
    @Test("String.email validator fails for invalid email addresses")
    func emailFailsForInvalidEmails() throws {
        @Validated(.isEmailAddress)
        var invalidValue1 = "not-an-email"
        
        #expect(!$invalidValue1.isValid)
        #expect($invalidValue1.errors.count == 1)
        #expect($invalidValue1.errors.first?.message.contains("is not an email") ?? false)
        
        @Validated(.isEmailAddress)
        var invalidValue2 = "missing@domain"
        
        #expect(!$invalidValue2.isValid)
    }
    
    // MARK: - contains
    
    @Test("String.contains validator passes for strings containing substring")
    func containsPassesWhenSubstringExists() throws {
        @Validated(.contains("test"))
        var validValue = "This is a test string"
        
        #expect($validValue.isValid)
    }
    
    @Test("String.contains validator respects case sensitivity")
    func containsRespectsCaseSensitivity() throws {
        @Validated(.contains("Test", caseSensitive: true))
        var invalidValue = "this is a test string"
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Value does not contain 'Test'")
        
        @Validated(.contains("Test", caseSensitive: false))
        var validValue = "this is a test string"
        
        #expect($validValue.isValid)
    }
    
    @Test("String.contains validator fails when substring is missing")
    func containsFailsWhenSubstringMissing() throws {
        @Validated(.contains("missing"))
        var invalidValue = "This is a test string"
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Value does not contain 'missing'")
    }
    
    // MARK: - alphaNumeric
    
    @Test("String.alphaNumeric validator passes for alphanumeric strings")
    func alphaNumericPassesForValidStrings() throws {
        @Validated(.isAlphaNumeric)
        var validValue1 = "abc123"
        
        #expect($validValue1.isValid)
        
        @Validated(.isAlphaNumeric)
        var validValue2 = "ABC123"
        
        #expect($validValue2.isValid)
    }
    
    @Test("String.alphaNumeric validator fails for non-alphanumeric strings")
    func alphaNumericFailsForInvalidStrings() throws {
        @Validated(.isAlphaNumeric)
        var invalidValue = "abc-123"
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Value contains non-alphanumeric characters")
    }
}

@Suite("Collection Validators")
struct CollectionValidatorsTests {
    
    // MARK: - notEmpty
    
    @Test("Collection.notEmpty validator passes for non-empty collections")
    func notEmptyPassesForNonEmptyCollection() throws {
        @Validated(.isNotEmpty)
        var validArray = [1, 2, 3]
        
        #expect($validArray.isValid)
        
        @Validated(.isNotEmpty)
        var validString = "test"
        
        #expect($validString.isValid)
    }
    
    @Test("Collection.notEmpty validator fails for empty collections")
    func notEmptyFailsForEmptyCollection() throws {
        @Validated(.isNotEmpty)
        var invalidArray: [Int] = []
        
        #expect(!$invalidArray.isValid)
        #expect($invalidArray.errors.count == 1)
        #expect($invalidArray.errors.first?.message == "Collection is empty")
    }
    
    // MARK: - lessThan
    
    @Test("Collection.lessThan validator passes for collections with count less than bound")
    func lessThanPassesForValidCount() throws {
        @Validated(.isLessThan(5))
        var validArray = [1, 2, 3]
        
        #expect($validArray.isValid)
    }
    
    @Test("Collection.lessThan validator fails for collections with count >= bound")
    func lessThanFailsForInvalidCount() throws {
        @Validated(.isLessThan(3))
        var invalidArray = [1, 2, 3]
        
        #expect(!$invalidArray.isValid)
        #expect($invalidArray.errors.count == 1)
        #expect($invalidArray.errors.first?.message.contains("Collection count 3 is >= 3") ?? false)
        
        @Validated(.isLessThan(3))
        var invalidArray2 = [1, 2, 3, 4]
        
        #expect(!$invalidArray2.isValid)
    }
    
    // MARK: - greaterThan
    
    @Test("Collection.greaterThan validator passes for collections with count greater than bound")
    func greaterThanPassesForValidCount() throws {
        @Validated(.isGreaterThan(2))
        var validArray = [1, 2, 3]
        
        #expect($validArray.isValid)
    }
    
    @Test("Collection.greaterThan validator fails for collections with count <= bound")
    func greaterThanFailsForInvalidCount() throws {
        @Validated(.isGreaterThan(3))
        var invalidArray = [1, 2, 3]
        
        #expect(!$invalidArray.isValid)
        #expect($invalidArray.errors.count == 1)
        #expect($invalidArray.errors.first?.message.contains("Collection count 3 is <= 3") ?? false)
        
        @Validated(.isGreaterThan(3))
        var invalidArray2 = [1, 2]
        
        #expect(!$invalidArray2.isValid)
    }
    
    // MARK: - between
    
    @Test("Collection.between validator passes for collections with count within bounds")
    func betweenPassesForValidCount() throws {
        @Validated(.isBetween(2, 4))
        var validArray1 = [1, 2]
        
        #expect($validArray1.isValid)
        
        @Validated(.isBetween(2, 4))
        var validArray2 = [1, 2, 3, 4]
        
        #expect($validArray2.isValid)
    }
    
    @Test("Collection.between validator fails for collections with count outside bounds")
    func betweenFailsForInvalidCount() throws {
        @Validated(.isBetween(2, 4))
        var invalidArray1 = [1]
        
        #expect(!$invalidArray1.isValid)
        #expect($invalidArray1.errors.count == 1)
        #expect($invalidArray1.errors.first?.message.contains("Collection count 1 is < 2") ?? false)
        
        @Validated(.isBetween(2, 4))
        var invalidArray2 = [1, 2, 3, 4, 5]
        
        #expect(!$invalidArray2.isValid)
        #expect($invalidArray2.errors.count == 1)
        #expect($invalidArray2.errors.first?.message.contains("Collection count 5 is > 4") ?? false)
    }
    
    // MARK: - contains
    
    @Test("Collection.contains validator passes when element exists")
    func containsPassesWhenElementExists() throws {
        @Validated(.contains(2))
        var validArray = [1, 2, 3]
        
        #expect($validArray.isValid)
    }
    
    @Test("Collection.contains validator fails when element doesn't exist")
    func containsFailsWhenElementMissing() throws {
        @Validated(.contains(4))
        var invalidArray = [1, 2, 3]
        
        #expect(!$invalidArray.isValid)
        #expect($invalidArray.errors.count == 1)
        #expect($invalidArray.errors.first?.message == "Collection does not contain required element")
    }
    
    // MARK: - allPass
    
    @Test("Collection.allPass validator passes when all elements pass validation")
    func allPassPassesWhenAllElementsValid() throws {
        let isPositive = { (value: Int) throws(ValidationError) in
            if value <= 0 {
                throw ValidationError(message: "Value is not positive")
            }
        }
        
        @Validated(.allPass(isPositive))
        var validArray = [1, 2, 3]
        
        #expect($validArray.isValid)
    }
    
    @Test("Collection.allPass validator fails when any element fails validation")
    func allPassFailsWhenAnyElementInvalid() throws {
        let isPositive = { (value: Int) throws(ValidationError) in
            if value <= 0 {
                throw ValidationError(message: "Value is not positive")
            }
        }
        
        @Validated(.allPass(isPositive))
        var invalidArray = [1, 0, 3]
        
        #expect(!$invalidArray.isValid)
        #expect($invalidArray.errors.count == 1)
        #expect($invalidArray.errors.first?.message.contains("Element validation failed") ?? false)
    }
}

@Suite("Date Validators")
struct DateValidatorsTests {
    let pastDate = Date(timeIntervalSinceNow: -86400) // 1 day ago
    let futureDate = Date(timeIntervalSinceNow: 86400) // 1 day in future
    
    // MARK: - isPast
    
    @Test("Date.isPast validator passes for past dates")
    func isPastPassesForPastDates() throws {
        @Validated(.isInThePast)
        var validDate = pastDate
        
        #expect($validDate.isValid)
    }
    
    @Test("Date.isPast validator fails for future dates")
    func isPastFailsForFutureDates() throws {
        @Validated(.isInThePast)
        var invalidDate = futureDate
        
        #expect(!$invalidDate.isValid)
        #expect($invalidDate.errors.count == 1)
        #expect($invalidDate.errors.first?.message == "Date is not in the past")
    }
    
    // MARK: - isFuture
    
    @Test("Date.isFuture validator passes for future dates")
    func isFuturePassesForFutureDates() throws {
        @Validated(.isInTheFuture)
        var validDate = futureDate
        
        #expect($validDate.isValid)
    }
    
    @Test("Date.isFuture validator fails for past dates")
    func isFutureFailsForPastDates() throws {
        @Validated(.isInTheFuture)
        var invalidDate = pastDate
        
        #expect(!$invalidDate.isValid)
        #expect($invalidDate.errors.count == 1)
        #expect($invalidDate.errors.first?.message == "Date is not in the future")
    }
    
    // MARK: - isAfter
    
    @Test("Date.isAfter validator passes for dates after reference")
    func isAfterPassesForLaterDates() throws {
        let reference = pastDate.addingTimeInterval(-86400) // 2 days ago
        
        @Validated(.isAfter(reference))
        var validDate = pastDate
        
        #expect($validDate.isValid)
    }
    
    @Test("Date.isAfter validator fails for dates before/equal to reference")
    func isAfterFailsForEarlierOrEqualDates() throws {
        let reference = pastDate
        
        @Validated(.isAfter(reference))
        var invalidDate = pastDate
        
        #expect(!$invalidDate.isValid)
        #expect($invalidDate.errors.count == 1)
        #expect($invalidDate.errors.first?.message.contains("Date is not after") ?? false)
    }
    
    // MARK: - isBefore
    
    @Test("Date.isBefore validator passes for dates before reference")
    func isBeforePassesForEarlierDates() throws {
        let reference = futureDate.addingTimeInterval(86400) // 2 days in future
        
        @Validated(.isBefore(reference))
        var validDate = futureDate
        
        #expect($validDate.isValid)
    }
    
    @Test("Date.isBefore validator fails for dates after/equal to reference")
    func isBeforeFailsForLaterOrEqualDates() throws {
        let reference = futureDate
        
        @Validated(.isBefore(reference))
        var invalidDate = futureDate
        
        #expect(!$invalidDate.isValid)
        #expect($invalidDate.errors.count == 1)
        #expect($invalidDate.errors.first?.message.contains("Date is not before") ?? false)
    }
    
    // MARK: - isLessThanOrEqualTo
    @Test("Comparable.isLessThanOrEqualTo validator passes for values less than or equal to bound")
    func isLessThanOrEqualToPassesForValuesAtOrBelowBound() throws {
        @Validated(.isLessThanOrEqualTo(10))
        var validValue1 = 10

        #expect($validValue1.isValid)

        @Validated(.isLessThanOrEqualTo(10))
        var validValue2 = 5

        #expect($validValue2.isValid)
    }

    @Test("Comparable.isLessThanOrEqualTo validator fails for values greater than bound")
    func isLessThanOrEqualToFailsForInvalidValues() throws {
        @Validated(.isLessThanOrEqualTo(10))
        var invalidValue = 11

        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Value is not less than or equal to 10")
    }

    // MARK: - isBetween
    
    @Test("Date.isBetween validator passes for dates within range")
    func isBetweenPassesForDatesInRange() throws {
        let start = pastDate
        let end = futureDate
        let middle = Date() // Now should be between past and future
        
        @Validated(.isBetween(start, end))
        var validDate = middle
        
        #expect($validDate.isValid)
    }
    
    @Test("Date.isBetween validator fails for dates outside range")
    func isBetweenFailsForDatesOutsideRange() throws {
        let start = pastDate
        let end = futureDate
        let tooEarly = pastDate.addingTimeInterval(-86400) // 2 days ago
        
        @Validated(.isBetween(start, end))
        var invalidDate = tooEarly
        
        #expect(!$invalidDate.isValid)
        #expect($invalidDate.errors.count == 1)
        #expect($invalidDate.errors.first?.message.contains("Date is before") ?? false)
        
        let tooLate = futureDate.addingTimeInterval(86400) // 2 days in future
        
        @Validated(.isBetween(start, end))
        var invalidDate2 = tooLate
        
        #expect(!$invalidDate2.isValid)
        #expect($invalidDate2.errors.count == 1)
        #expect($invalidDate2.errors.first?.message.contains("Date is after") ?? false)
    }
    
    // MARK: - isWeekday
    
    @Test("Date.isWeekday validator passes for weekdays")
    func isWeekdayPassesForWeekdays() throws {
        // Create a known weekday (e.g., Monday, which is 2 in Calendar)
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2025
        components.month = 6
        components.day = 2 // June 2, 2025 is a Monday
        let monday = calendar.date(from: components)!
        
        @Validated(.isAWeekday)
        var validDate = monday
        
        #expect($validDate.isValid)
    }
    
    @Test("Date.isWeekday validator fails for weekends")
    func isWeekdayFailsForWeekends() throws {
        // Create a known weekend (e.g., Sunday, which is 1 in Calendar)
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2025
        components.month = 6
        components.day = 1 // June 1, 2025 is a Sunday
        let sunday = calendar.date(from: components)!
        
        @Validated(.isAWeekday)
        var invalidDate = sunday
        
        #expect(!$invalidDate.isValid)
        #expect($invalidDate.errors.count == 1)
        #expect($invalidDate.errors.first?.message == "Date is not a weekday")
    }
    
    // MARK: - isWeekend
    
    @Test("Date.isWeekend validator passes for weekends")
    func isWeekendPassesForWeekends() throws {
        // Create a known weekend (e.g., Saturday, which is 7 in Calendar)
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2025
        components.month = 6
        components.day = 7 // June 7, 2025 is a Saturday
        let saturday = calendar.date(from: components)!
        
        @Validated(.isAtTheWeekend)
        var validDate = saturday
        
        #expect($validDate.isValid)
    }
    
    @Test("Date.isWeekend validator fails for weekdays")
    func isWeekendFailsForWeekdays() throws {
        // Create a known weekday (e.g., Monday, which is 2 in Calendar)
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2025
        components.month = 6
        components.day = 2 // June 2, 2025 is a Monday
        let monday = calendar.date(from: components)!
        
        @Validated(.isAtTheWeekend)
        var invalidDate = monday
        
        #expect(!$invalidDate.isValid)
        #expect($invalidDate.errors.count == 1)
        #expect($invalidDate.errors.first?.message == "Date is not a weekend")
    }
}

@Suite("BinaryInteger Validators")
struct BinaryIntegerValidatorsTests {
    
    // MARK: - isMultipleOf
    
    @Test("BinaryInteger.isMultipleOf validator passes for multiples")
    func isMultipleOfPassesForValidValues() throws {
        @Validated(.isMultipleOf(3))
        var validValue = 9
        
        #expect($validValue.isValid)
    }
    
    @Test("BinaryInteger.isMultipleOf validator fails for non-multiples")
    func isMultipleOfFailsForInvalidValues() throws {
        @Validated(.isMultipleOf(3))
        var invalidValue = 10
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Value is not a multiple of 3")
    }
    
    // MARK: - isEven
    
    @Test("BinaryInteger.isEven validator passes for even numbers")
    func isEvenPassesForEvenNumbers() throws {
        @Validated(.isEven)
        var validValue = 4
        
        #expect($validValue.isValid)
    }
    
    @Test("BinaryInteger.isEven validator fails for odd numbers")
    func isEvenFailsForOddNumbers() throws {
        @Validated(.isEven)
        var invalidValue = 5
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Value is not even")
    }
    
    // MARK: - isOdd
    
    @Test("BinaryInteger.isOdd validator passes for odd numbers")
    func isOddPassesForOddNumbers() throws {
        @Validated(.isOdd)
        var validValue = 5
        
        #expect($validValue.isValid)
    }
    
    @Test("BinaryInteger.isOdd validator fails for even numbers")
    func isOddFailsForEvenNumbers() throws {
        @Validated(.isOdd)
        var invalidValue = 4
        
        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Value is not odd")
    }
}

@Suite("Comparable Validators")
struct ComparableValidatorsTests {
    
    // MARK: - isGreaterThan
    
    @Test("Comparable.isGreaterThan validator passes for values greater than bound")
    func isGreaterThanPassesForValidValues() throws {
        @Validated(.isGreaterThan(5))
        var validValue = 10
        
        #expect($validValue.isValid)
    }
    
    @Test("Comparable.isGreaterThan validator fails for values <= bound")
    func isGreaterThanFailsForInvalidValues() throws {
        @Validated(.isGreaterThan(5))
        var invalidValue1 = 5
        
        #expect(!$invalidValue1.isValid)
        #expect($invalidValue1.errors.count == 1)
        #expect($invalidValue1.errors.first?.message == "Value is not greater than 5")
        
        @Validated(.isGreaterThan(5))
        var invalidValue2 = 4
        
        #expect(!$invalidValue2.isValid)
    }
    
    // MARK: - isGreaterThanOrEqualTo
    @Test("Comparable.isGreaterThanOrEqualTo validator passes for values greater than or equal to bound")
    func isGreaterThanOrEqualToPassesForValuesAtOrAboveBound() throws {
        @Validated(.isGreaterThanOrEqualTo(5))
        var validValue1 = 5

        #expect($validValue1.isValid)

        @Validated(.isGreaterThanOrEqualTo(5))
        var validValue2 = 10

        #expect($validValue2.isValid)
    }

    @Test("Comparable.isGreaterThanOrEqualTo validator fails for values less than bound")
    func isGreaterThanOrEqualToFailsForInvalidValues() throws {
        @Validated(.isGreaterThanOrEqualTo(5))
        var invalidValue = 4

        #expect(!$invalidValue.isValid)
        #expect($invalidValue.errors.count == 1)
        #expect($invalidValue.errors.first?.message == "Value is not greater than or equal to 5")
    }

    // MARK: - isLessThan
    
    @Test("Comparable.isLessThan validator passes for values less than bound")
    func isLessThanPassesForValidValues() throws {
        @Validated(.isLessThan(10))
        var validValue = 5
        
        #expect($validValue.isValid)
    }
    
    @Test("Comparable.isLessThan validator fails for values >= bound")
    func isLessThanFailsForInvalidValues() throws {
        @Validated(.isLessThan(10))
        var invalidValue1 = 10
        
        #expect(!$invalidValue1.isValid)
        #expect($invalidValue1.errors.count == 1)
        #expect($invalidValue1.errors.first?.message == "Value is not less than 10")
        
        @Validated(.isLessThan(10))
        var invalidValue2 = 15
        
        #expect(!$invalidValue2.isValid)
    }
    
    // MARK: - isBetween
    
    @Test("Comparable.isBetween validator passes for values within bounds")
    func isBetweenPassesForValidValues() throws {
        @Validated(.isBetween(5, 10))
        var validValue1 = 5
        
        #expect($validValue1.isValid)
        
        @Validated(.isBetween(5, 10))
        var validValue2 = 10
        
        #expect($validValue2.isValid)
        
        @Validated(.isBetween(5, 10))
        var validValue3 = 7
        
        #expect($validValue3.isValid)
    }
    
    @Test("Comparable.isBetween validator fails for values outside bounds")
    func isBetweenFailsForInvalidValues() throws {
        @Validated(.isBetween(5, 10))
        var invalidValue1 = 4
        
        #expect(!$invalidValue1.isValid)
        #expect($invalidValue1.errors.count == 1)
        #expect($invalidValue1.errors.first?.message == "Value is less than 5")
        
        @Validated(.isBetween(5, 10))
        var invalidValue2 = 11
        
        #expect(!$invalidValue2.isValid)
        #expect($invalidValue2.errors.count == 1)
        #expect($invalidValue2.errors.first?.message == "Value is greater than 10")
    }
}

@Suite("Numeric & Comparable Validators")
struct NumericAndComparableValidatorsTests {
    
    // MARK: - isPositive
    
    @Test("NumericAndComparable.isPositive validator passes for positive values")
    func isPositivePassesForPositiveValues() throws {
        @Validated(.isPositive)
        var validValue = 10
        
        #expect($validValue.isValid)
    }
    
    @Test("NumericAndComparable.isPositive validator fails for zero and negative values")
    func isPositiveFailsForZeroAndNegativeValues() throws {
        @Validated(.isPositive)
        var invalidValue1 = 0
        
        #expect(!$invalidValue1.isValid)
        #expect($invalidValue1.errors.count == 1)
        #expect($invalidValue1.errors.first?.message == "Number is not positive")
        
        @Validated(.isPositive)
        var invalidValue2 = -5
        
        #expect(!$invalidValue2.isValid)
    }
    
    // MARK: - isNegative
    
    @Test("NumericAndComparable.isNegative validator passes for negative values")
    func isNegativePassesForNegativeValues() throws {
        @Validated(.isNegative)
        var validValue = -10
        
        #expect($validValue.isValid)
    }
    
    @Test("NumericAndComparable.isNegative validator fails for zero and positive values")
    func isNegativeFailsForZeroAndPositiveValues() throws {
        @Validated(.isNegative)
        var invalidValue1 = 0
        
        #expect(!$invalidValue1.isValid)
        #expect($invalidValue1.errors.count == 1)
        #expect($invalidValue1.errors.first?.message == "Number is not negative")
        
        @Validated(.isNegative)
        var invalidValue2 = 5
        
        #expect(!$invalidValue2.isValid)
    }
}
