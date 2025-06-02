import Livestock
import Testing

@Suite("AnyValidator.multiple Tests")
struct AnyValidatorMultipleTests {

    @Test("multiple validator passes when all validators pass")
    func multipleValidatorPasses() throws {
        @Validated(.multiple([.isGreaterThan(0), .isLessThan(10)]))
        var validValue = 5

        let errors = $validValue.errors
        #expect(errors.isEmpty)
    }

    @Test("multiple validator fails when at least one validator fails")
    func multipleValidatorFails() throws {
        @Validated(.multiple([.isGreaterThan(0), .isLessThan(10)]))
        var invalidValue = -1

        let errors = $invalidValue.errors
        #expect(errors.count == 1)
        #expect(errors[0].message == "Value is not greater than 0")
    }
}
