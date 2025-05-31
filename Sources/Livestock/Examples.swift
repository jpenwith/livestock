//
//  Examples.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//



struct User {
    @Validated(.notEmpty, .lessThan(10), .between(0, 10)) var name: String = ""
    
    // Using the new ValidatedOptional property wrapper
    @OptionalValidated(.notRequired, .notEmpty, .lessThan(10)) var nickname: String? = nil
    
    // Alternative way to define optional validation
    @OptionalValidated(.notRequired, .notEmpty, .greaterThan(3)) var email: String? = nil
    
    // Example with custom validation for optional
    @OptionalValidated var phoneNumber: String? = nil
    
    init(name: String, nickname: String? = nil, email: String? = nil, phoneNumber: String? = nil) {
        self.name = name
        self.nickname = nickname
        self.email = email
        self.phoneNumber = phoneNumber
    }
}

//// Example of using optional validators
//struct Profile {
//    // Using .optional() extension to convert regular validators to optional validators
//    @ValidatedOptional(AnyValidator<String>.notEmpty.optional()) var bio: String?
//    
//    // Requiring a non-nil value for an optional field
//    @ValidatedOptional(AnyValidator<String>.notEmpty.optional(allowNil: false)) var username: String?
//}
