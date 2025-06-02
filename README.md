# Livestock - Swift Validation Library

[![Swift](https://img.shields.io/badge/Swift-5.6%2B-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Livestock is a powerful, type-safe validation library for Swift that uses property wrappers to implement clean, declarative validations in your models.

## Features

- 📦 **Property Wrapper Based**: Use `@Validated` to define validation rules directly on your properties
- 🔍 **Type-Safe**: All validations are type-specific and checked at compile time
- 🔄 **Multiple Validations**: Apply multiple validation rules to a single property
- 🛠️ **Composable Validators**: Mix and match individual validator components
- 🧩 **Protocol-Based**: Create custom validators by implementing the `Validator` protocol
- 🚦 **Rich Validation State**: Access validation state through projected values
- 📱 **Swift Platform Support**: Works on iOS, macOS, watchOS, and tvOS

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/livestock.git", from: "1.0.0")
]
```

## Usage

### Basic Usage

```swift
import Livestock

struct User {
    @Validated(.isEmailAddress)
    var email: String
    
    @Validated(.isGreaterThan(18))
    var age: Int
    
    @Validated(.isInThePast)
    var dateOfBirth: Date
    
    @Validated(.isNotEmpty, .isLessThanOrEqualTo(50))
    var username: String
}

// Create a user
var user = User(email: "user@example.com", age: 25, dateOfBirth: Date().addingTimeInterval(-86400 * 365 * 20), username: "user123")

// Check validation
if user.$email.isValid {
    print("Email is valid")
}

// Get validation errors
if let usernameError = user.$username.errorMessage {
    print("Username error: \(usernameError)")
}
```

### Available Validators

Below is a summary of built-in validators and their corresponding static `AnyValidator` extensions:

**String Validators**
- `.isNotEmpty` (`Validators.String.IsNotEmpty`)
- `.isLessThan(_ upperBound: Int)` (`Validators.String.IsCountLessThan`)
- `.isLessThanOrEqualTo(_ upperBound: Int)` (`Validators.String.IsCountLessThanOrEqualTo`)
- `.isGreaterThan(_ lowerBound: Int)` (`Validators.String.IsCountGreaterThan`)
- `.isGreaterThanOrEqualTo(_ lowerBound: Int)` (`Validators.String.IsCountGreaterThanOrEqualTo`)
- `.isBetween(_ lowerBound: Int, _ upperBound: Int)` (`Validators.String.IsCountBetween`)
- `.matches(_ regex: Regex<Substring>)` (`Validators.String.Matches`)
- `.isEmailAddress` (`Validators.String.IsEmailAddress`)
- `.contains(_ substring: String, caseSensitive: Bool = true)` (`Validators.String.Contains`)

**Comparable Validators**
- `.isGreaterThan(_ lowerBound: Value)` (`Validators.Comparable.IsGreaterThan`)
- `.isGreaterThanOrEqualTo(_ lowerBound: Value)` (`Validators.Comparable.IsGreaterThanOrEqualTo`)
- `.isLessThan(_ upperBound: Value)` (`Validators.Comparable.IsLessThan`)
- `.isLessThanOrEqualTo(_ upperBound: Value)` (`Validators.Comparable.IsLessThanOrEqualTo`)
- `.isBetween(_ lowerBound: Value, _ upperBound: Value)` (`Validators.Comparable.IsBetween`)

**Numeric & Comparable Validators**
- `.isPositive` (`Validators.NumericAndComparable.IsPositive`)
- `.isNegative` (`Validators.NumericAndComparable.IsNegative`)

**Binary Integer Validators**
- `.isMultipleOf(_ divisor: T)` (`Validators.Numeric.BinaryInteger.IsMultipleOf`)
- `.isEven` (`Validators.Numeric.BinaryInteger.IsEven`)
- `.isOdd` (`Validators.Numeric.BinaryInteger.IsOdd`)

**Collection Validators**
- `.isNotEmpty` (`Validators.Collection.IsNotEmpty`)
- `.isLessThan(_ upperBound: Int)` (`Validators.Collection.IsCountLessThan`)
- `.isGreaterThan(_ lowerBound: Int)` (`Validators.Collection.IsCountGreaterThan`)
- `.isBetween(_ lowerBound: Int, _ upperBound: Int)` (`Validators.Collection.IsCountBetween`)
- `.allPass(_ validator: @escaping (Element) throws(ValidationError) -> Void)` (`Validators.Collection.AllElementsPass`)

**Date Validators**
- `.isInThePast` (`Validators.Date.IsInThePast`)
- `.isInTheFuture` (`Validators.Date.IsInTheFuture`)
- `.isAfter(_ date: Date)` (`Validators.Date.IsAfter`)
- `.isBefore(_ date: Date)` (`Validators.Date.IsBefore`)
- `.isBetween(_ startDate: Date, _ endDate: Date)` (`Validators.Date.IsBetween`)
- `.isAWeekday` (`Validators.Date.IsAWeekday`)
- `.isAtTheWeekend` (`Validators.Date.IsAtTheWeekend`)

**Custom Validators**
- `.custom(_ validator: @escaping (Value) throws(ValidationError) -> Void)` (`Validators.Custom`)

### Checking Validation State

Each property decorated with `@Validated` gets a projected value that provides validation information:

```swift
// Check if valid
let isEmailValid = user.$email.isValid

// Get validation errors
let emailErrors = user.$email.errors 

// Get combined error message
if let errorMessage = user.$email.errorMessage {
    print(errorMessage) 
}

// Check specific validation
let isUsernameNotEmpty = user.$username.validate(with: .isNotEmpty)

// Check all validations
let allValid = user.$username.validateAll()
```

### Model-Level Validation

```swift
struct User {
    @Validated(.email)
    var email: String
    
    @Validated(.greaterThan(18))
    var age: Int
    
    // Check if all properties are valid
    var isValid: Bool {
        return $email.isValid && $age.isValid
    }
    
    // Get all validation errors
    var validationErrors: [String] {
        var errors: [String] = []
        
        if !$email.isValid, let error = $email.errorMessage {
            errors.append("Email: \(error)")
        }
        
        if !$age.isValid, let error = $age.errorMessage {
            errors.append("Age: \(error)")
        }
        
        return errors
    }
}
```

### Creating Custom Validators

You can create custom validators in two ways:

#### 1. Using the CustomValidator struct:

```swift
// Create custom validation rule
let passwordRule = ValidationRule<String>.custom({ password in
    // At least 8 characters, one uppercase, one lowercase, one digit
    let regex = try! NSRegularExpression(pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$")
    let range = NSRange(location: 0, length: password.utf16.count)
    return regex.firstMatch(in: password, range: range) != nil
}, errorMessage: "Password must be at least 8 characters with 1 uppercase, 1 lowercase, and 1 digit")

struct LoginForm {
    @Validated(.email)
    var email: String
    
    // Use custom validation rule
    @Validated(rules: [passwordRule])
    var password: String
}
```

#### 2. Creating a custom validator struct:

```swift
// Create a custom validator struct
public struct PasswordValidator<Value>: Validator where Value == String {
    public init() {}
    
    public func validate(_ value: Value) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$")
        let range = NSRange(location: 0, length: value.utf16.count)
        return regex.firstMatch(in: value, range: range) != nil
    }
    
    public var errorMessage: String {
        return "Password must be at least 8 characters with 1 uppercase, 1 lowercase, and 1 digit"
    }
}

// Add an extension to ValidationRule
public extension ValidationRule where Value == String {
    static var password: ValidationRule<String> {
        return ValidationRule(validator: PasswordValidator<String>())
    }
}

// Use in your model
struct LoginForm {
    @Validated(.email)
    var email: String
    
    @Validated(.password)
    var password: String
}
```

## Architecture

Livestock is built around these core components:

1. **Validator Protocol**: The foundation of the library, defining how a validator checks a value:
   ```swift
   public protocol Validator {
       associatedtype Value
       func validate(_ value: Value) -> Bool
       var errorMessage: String { get }
   }
   ```

2. **Individual Validator Structs**: Each validation rule is implemented as a separate struct:
   ```swift
   public struct EmailValidator<Value>: Validator where Value == String {
       public func validate(_ value: Value) -> Bool { ... }
       public var errorMessage: String { ... }
   }
   ```

3. **ValidationRule**: A wrapper that provides a consistent interface to validators:
   ```swift
   public struct ValidationRule<Value>: Validator {
       private let validator: any Validator<Value>
       public init(validator: any Validator<Value>) { ... }
   }
   ```

4. **Validated Property Wrapper**: Connects the validation system to Swift properties:
   ```swift
   @propertyWrapper
   public struct Validated<Value> {
       public var wrappedValue: Value { get set }
       public var projectedValue: ValidationState<Value> { get }
   }
   ```

This architecture allows for maximum flexibility while maintaining a simple and intuitive API.

## License

Livestock is available under the MIT license. See the LICENSE file for more info.
