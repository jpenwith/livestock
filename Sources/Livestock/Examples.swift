//
//  Examples.swift
//  Livestock
//
//  Created by James Penwith on 31/05/2025.
//



struct User {
    @Validated(.notEmpty, .lessThan(10), .between(0, 10)) var name: String = ""
}
