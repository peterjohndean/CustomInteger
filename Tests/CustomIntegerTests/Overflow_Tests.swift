/*
 * This file is part of Custom Integer (Swift Package).
 *
 * Copyright (C) 2025 Peter Dean
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

import Testing
@testable import CustomInteger

struct Overflow_Tests {
    
    @Test func leftShiftOverflow_Tests() async throws {
        if let a = CustomInteger(for: 32) {
            #expect(a.leftShiftReportingOverflow(0 as Int32, by: 0) == false)    // No shift, no overflow
            #expect(a.leftShiftReportingOverflow(0 as Int32, by: 10) == false)   // Zero value, no overflow
            #expect(a.leftShiftReportingOverflow(0 as Int32, by: -1) == false)   // Negative shift (invalid, no overflow)
            
            #expect(a.leftShiftReportingOverflow(1 as Int32, by: 0) == false)    // No shift, no overflow
            #expect(a.leftShiftReportingOverflow(1 as Int32, by: 31) == true)    // Maximum shift for signed Int32, overflow
            #expect(a.leftShiftReportingOverflow(1 as Int32, by: 32) == true)    // Shift > bitWidth, always overflow
            #expect(a.leftShiftReportingOverflow(1 as UInt32, by: 31) == false)  // Maximum safe shift for unsigned
            #expect(a.leftShiftReportingOverflow(1 as UInt32, by: 32) == true)   // Shift > bitWidth, overflow
            
            #expect(a.leftShiftReportingOverflow(-1 as Int32, by: 0) == false)   // No shift, no overflow
            #expect(a.leftShiftReportingOverflow(-1 as Int32, by: 31) == true)   // Maximum shift, overflow
            #expect(a.leftShiftReportingOverflow(-1 as Int32, by: 32) == true)   // Shift > bitWidth, overflow
            #expect(a.leftShiftReportingOverflow(-1 as Int32, by: 1) == true)    // Immediate overflow due to all 1's
            
            #expect(a.leftShiftReportingOverflow(Int32.max, by: 1) == true)      // Overflow by doubling the max value
            #expect(a.leftShiftReportingOverflow(Int32.min, by: 1) == true)      // Overflow by doubling the min value
            #expect(a.leftShiftReportingOverflow(UInt32.max, by: 1) == true)     // Overflow by doubling the max unsigned value
            
            #expect(a.leftShiftReportingOverflow(1 as Int32, by: 100) == true)   // Shift >> bitWidth, overflow
            #expect(a.leftShiftReportingOverflow(1 as Int32, by: -100) == false) // Negative shift, no overflow
            #expect(a.leftShiftReportingOverflow(0 as Int32, by: 100) == false)  // Zero value, no overflow
            
            #expect(a.leftShiftReportingOverflow(UInt32.max, by: 1) == true)     // Overflow for maximum unsigned value
            #expect(a.leftShiftReportingOverflow(1 as UInt32, by: 0) == false)   // No shift, no overflow
            #expect(a.leftShiftReportingOverflow(1 as UInt32, by: 31) == false)  // Safe maximum shift
            #expect(a.leftShiftReportingOverflow(1 as UInt32, by: 32) == true)   // Overflow for shift == bitWidth
        }
        
        if let a = CustomInteger(for: 64) {
            #expect(a.leftShiftReportingOverflow(0 as Int64, by: 0) == false)    // No shift, no overflow
            #expect(a.leftShiftReportingOverflow(0 as Int64, by: 10) == false)   // Zero value, no overflow
            #expect(a.leftShiftReportingOverflow(0 as Int64, by: -1) == false)   // Negative shift (invalid, no overflow)
            
            #expect(a.leftShiftReportingOverflow(1 as Int64, by: 0) == false)    // No shift, no overflow
            #expect(a.leftShiftReportingOverflow(1 as Int64, by: 63) == true)    // Maximum shift for signed Int64, overflow
            #expect(a.leftShiftReportingOverflow(1 as Int64, by: 64) == true)    // Shift > bitWidth, always overflow
            #expect(a.leftShiftReportingOverflow(1 as UInt64, by: 63) == false)  // Maximum safe shift for unsigned
            #expect(a.leftShiftReportingOverflow(1 as UInt64, by: 64) == true)   // Shift > bitWidth, overflow
            
            #expect(a.leftShiftReportingOverflow(-1 as Int64, by: 0) == false)   // No shift, no overflow
            #expect(a.leftShiftReportingOverflow(-1 as Int64, by: 63) == true)   // Maximum shift, overflow
            #expect(a.leftShiftReportingOverflow(-1 as Int64, by: 64) == true)   // Shift > bitWidth, overflow
            #expect(a.leftShiftReportingOverflow(-1 as Int64, by: 1) == true)    // Immediate overflow due to all 1's
            
            #expect(a.leftShiftReportingOverflow(Int64.max, by: 1) == true)      // Overflow by doubling the max value
            #expect(a.leftShiftReportingOverflow(Int64.min, by: 1) == true)      // Overflow by doubling the min value
            #expect(a.leftShiftReportingOverflow(UInt64.max, by: 1) == true)     // Overflow by doubling the max unsigned value
            
            #expect(a.leftShiftReportingOverflow(1 as Int64, by: 100) == true)   // Shift >> bitWidth, overflow
            #expect(a.leftShiftReportingOverflow(1 as Int64, by: -100) == false) // Negative shift, no overflow
            #expect(a.leftShiftReportingOverflow(0 as Int64, by: 100) == false)  // Zero value, no overflow
            
            #expect(a.leftShiftReportingOverflow(UInt64.max, by: 1) == true)     // Overflow for maximum unsigned value
            #expect(a.leftShiftReportingOverflow(1 as UInt64, by: 0) == false)   // No shift, no overflow
            #expect(a.leftShiftReportingOverflow(1 as UInt64, by: 63) == false)  // Safe maximum shift
            #expect(a.leftShiftReportingOverflow(1 as UInt64, by: 64) == true)   // Overflow for shift == bitWidth
        }
    }
    
    @Test func multiplicationReportOverflow_Tests() {
        if let a = CustomInteger(for: 64) {
            #expect(a.multiplicationReportOverflow(lhs: 0 as Int64, rhs: 0 as Int64) == false)  // 0 * 0
            #expect(a.multiplicationReportOverflow(lhs: 1 as Int64, rhs: 0 as Int64) == false)  // 1 * 0
            #expect(a.multiplicationReportOverflow(lhs: 0 as Int64, rhs: 1 as Int64) == false)  // 0 * 1
            #expect(a.multiplicationReportOverflow(lhs: -1 as Int64, rhs: 0 as Int64) == false) // -1 * 0
            
            #expect(a.multiplicationReportOverflow(lhs: 2 as Int64, rhs: 3 as Int64) == false)  // 2 * 3 = 6
            #expect(a.multiplicationReportOverflow(lhs: Int64.max / 2 as Int64, rhs: 2 as Int64) == false)  // Maximum safe multiplication
            #expect(a.multiplicationReportOverflow(lhs: Int64.max, rhs: 2 as Int64) == true)   // Overflow (Int64 max * 2)
            
            #expect(a.multiplicationReportOverflow(lhs: -2 as Int64, rhs: -3 as Int64) == false)  // -2 * -3 = 6
            #expect(a.multiplicationReportOverflow(lhs: (Int64.min + 1) / 2 as Int64, rhs: -2 as Int64) == false)  // Maximum safe negative multiplication
            #expect(a.multiplicationReportOverflow(lhs: Int64.min, rhs: -2 as Int64) == true)   // Overflow (Int64 min * -2)
            
            #expect(a.multiplicationReportOverflow(lhs: Int64.max / 2 as Int64, rhs: 2 as Int64) == false)  // Safe for signed
            #expect(a.multiplicationReportOverflow(lhs: Int64.max / 2 as Int64, rhs: 3 as Int64) == true)   // Overflow
            #expect(a.multiplicationReportOverflow(lhs: Int64.min / 2 as Int64, rhs: 2 as Int64) == false)  // Safe for signed
            #expect(a.multiplicationReportOverflow(lhs: Int64.min / 2 as Int64, rhs: 3 as Int64) == true)   // Overflow
            
            #expect(a.multiplicationReportOverflow(lhs: UInt64.max / 2 as UInt64, rhs: 2 as UInt64) == false)  // Safe multiplication for unsigned
            #expect(a.multiplicationReportOverflow(lhs: UInt64.max / 2 as UInt64, rhs: 3 as UInt64) == true)   // Overflow
            #expect(a.multiplicationReportOverflow(lhs: UInt64.max, rhs: 2 as UInt64) == true)  // Overflow (UInt64 max * 2)
            
            #expect(a.multiplicationReportOverflow(lhs: Int64.max, rhs: 1 as Int64) == false) // Max signed * 1
            #expect(a.multiplicationReportOverflow(lhs: Int64.max, rhs: 2 as Int64) == true)  // Max signed * 2 (Overflow)
            #expect(a.multiplicationReportOverflow(lhs: Int64.min, rhs: -1 as Int64) == true) // Min signed * -1 (Overflow)
            #expect(a.multiplicationReportOverflow(lhs: UInt64.max, rhs: 2 as UInt64) == true) // Max unsigned * 2 (Overflow)
        }
    }
    
    @Test func divisionReportOverflow_Tests() {
        if let a = CustomInteger(for: 64) {
            #expect(a.divisionReportOverflow(lhs: 0 as Int64, rhs: 0 as Int64) == true)    // Division by zero
            #expect(a.divisionReportOverflow(lhs: 1 as Int64, rhs: 0 as Int64) == true)    // Division by zero
            #expect(a.divisionReportOverflow(lhs: -1 as Int64, rhs: 0 as Int64) == true)   // Division by zero
            
            #expect(a.divisionReportOverflow(lhs: Int64.max, rhs: 1 as Int64) == false)  // No overflow
            #expect(a.divisionReportOverflow(lhs: Int64.min, rhs: 1 as Int64) == false)  // No overflow
            #expect(a.divisionReportOverflow(lhs: 0 as Int64, rhs: 1 as Int64) == false)  // 0 / 1 = 0, no overflow
            #expect(a.divisionReportOverflow(lhs: 100 as Int64, rhs: 2 as Int64) == false) // No overflow (simple division)
            
            #expect(a.divisionReportOverflow(lhs: Int64.min, rhs: -1 as Int64) == true)  // Overflow: dividing Int64.min by -1 results in overflow
            
            #expect(a.divisionReportOverflow(lhs: Int64.min, rhs: 2 as Int64) == false)  // No overflow (safe division)
            #expect(a.divisionReportOverflow(lhs: Int64.max, rhs: -1 as Int64) == false) // No overflow for Int64.max / -1
            
            #expect(a.divisionReportOverflow(lhs: Int64.max, rhs: -2 as Int64) == false)  // No overflow for safe division with negative divisor
            #expect(a.divisionReportOverflow(lhs: -10 as Int64, rhs: -2 as Int64) == false) // No overflow for negative values
            
            #expect(a.divisionReportOverflow(lhs: Int64.max, rhs: Int64.max) == false)  // No overflow (max value divided by max value)
            #expect(a.divisionReportOverflow(lhs: Int64.min, rhs: Int64.min) == false)  // No overflow (min value divided by min value)
            
            #expect(a.divisionReportOverflow(lhs: 1 as Int64, rhs: 1 as Int64) == false)   // 1 / 1 = 1, no overflow
            #expect(a.divisionReportOverflow(lhs: 100 as Int64, rhs: 100 as Int64) == false) // 100 / 100 = 1, no overflow
            
            #expect(a.divisionReportOverflow(lhs: Int64.min + 1, rhs: -1 as Int64) == false) // Safe division for Int64.min + 1 by -1 (no overflow)
            #expect(a.divisionReportOverflow(lhs: Int64.min + 2, rhs: -1 as Int64) == false) // Safe division for Int64.min + 2 by -1 (no overflow)
            
            #expect(a.divisionReportOverflow(lhs: Int64.max / 2 as Int64, rhs: 2 as Int64) == false) // Safe division within range
            
            // Unsigned
            #expect(a.divisionReportOverflow(lhs: 0 as UInt64, rhs: 0 as UInt64) == true)    // Division by zero
            #expect(a.divisionReportOverflow(lhs: 1 as UInt64, rhs: 0 as UInt64) == true)    // Division by zero
            #expect(a.divisionReportOverflow(lhs: 100 as UInt64, rhs: 0 as UInt64) == true)  // Division by zero
            
            #expect(a.divisionReportOverflow(lhs: UInt64.max, rhs: 1 as UInt64) == false)    // No overflow: UInt64.max / 1 = UInt64.max
            #expect(a.divisionReportOverflow(lhs: UInt64.min, rhs: 1 as UInt64) == false)    // No overflow: UInt64.min / 1 = UInt64.min
            #expect(a.divisionReportOverflow(lhs: 0 as UInt64, rhs: 1 as UInt64) == false)    // No overflow: 0 / 1 = 0
            #expect(a.divisionReportOverflow(lhs: 100 as UInt64, rhs: 2 as UInt64) == false)  // No overflow: 100 / 2 = 50
            #expect(a.divisionReportOverflow(lhs: UInt64.max, rhs: 2 as UInt64) == false)    // No overflow: UInt64.max / 2
            
            #expect(a.divisionReportOverflow(lhs: 1 as UInt64, rhs: 1 as UInt64) == false)    // 1 / 1 = 1, no overflow
            #expect(a.divisionReportOverflow(lhs: 100 as UInt64, rhs: 100 as UInt64) == false) // 100 / 100 = 1, no overflow
            
            #expect(a.divisionReportOverflow(lhs: UInt64.max, rhs: UInt64.max) == false)    // No overflow: UInt64.max / UInt64.max = 1
            #expect(a.divisionReportOverflow(lhs: 1 as UInt64, rhs: UInt64.max) == false)    // 1 / UInt64.max = 0, no overflow
            
            #expect(a.divisionReportOverflow(lhs: 100 as UInt64, rhs: 200 as UInt64) == false) // 100 / 200 = 0, no overflow
            
            #expect(a.divisionReportOverflow(lhs: UInt64.min, rhs: UInt64.min) == true)    // No overflow: UInt64.min / UInt64.min = 1
        }
    }
    
    @Test func additionReportOverflow_Tests() {
        if let a = CustomInteger(for: 64) {
            #expect(a.additionReportOverflow(lhs: -1 as Int64, rhs: -Int64.max) == false) // Negative overflow beyond lower bound
            #expect(a.additionReportOverflow(lhs: -Int64.max / 2, rhs: -Int64.max / 2 - 1) == false) // Overflow due to adding negative values
            #expect(a.additionReportOverflow(lhs: UInt64.max / 2, rhs: UInt64.max / 2 + 1) == false) // No overflow
            
            #expect(a.additionReportOverflow(lhs: Int64.max, rhs: 1) == true) // Positive overflow
            #expect(a.additionReportOverflow(lhs: Int64.min, rhs: -1) == true) // Negative underflow
            #expect(a.additionReportOverflow(lhs: Int64.max / 2, rhs: Int64.max / 2) == false) // No overflow
            #expect(a.additionReportOverflow(lhs: Int64.min / 2, rhs: (-Int64.max - 1) / 2) == false) // No overflow
            #expect(a.additionReportOverflow(lhs: UInt64.max / 2, rhs: 1) == false) // No overflow
            
            // Signed
            #expect(a.additionReportOverflow(lhs: Int64.min, rhs: -1) == true) // Negative overflow: Int64.min - 1 < Int64.min
            #expect(a.additionReportOverflow(lhs: Int64.min, rhs: 0) == false) // No overflow: Int64.min + 0 = Int64.min
            #expect(a.additionReportOverflow(lhs: Int64.min, rhs: 1) == false) // No overflow: Int64.min + 1 > Int64.min
            
            #expect(a.additionReportOverflow(lhs: Int64.max, rhs: 1) == true) // Positive overflow: Int64.max + 1 > Int64.max
            #expect(a.additionReportOverflow(lhs: Int64.max, rhs: 0) == false) // No overflow: Int64.max + 0 = Int64.max
            #expect(a.additionReportOverflow(lhs: Int64.max, rhs: -1) == false) // No overflow: Int64.max - 1 < Int64.max
            
            #expect(a.additionReportOverflow(lhs: -1, rhs: -Int64.max) == false) // Negative overflow: -1 + (-Int64.max) < Int64.min
            #expect(a.additionReportOverflow(lhs: Int64.max / 2, rhs: Int64.max / 2) == false) // No overflow: Midpoint addition
            #expect(a.additionReportOverflow(lhs: Int64.max / 2, rhs: Int64.max / 2 + 1) == false) // No overflow: Edge case addition
            
            #expect(a.additionReportOverflow(lhs: -Int64.max / 2, rhs: -Int64.max / 2) == false) // No overflow: Midpoint addition for negatives
            #expect(a.additionReportOverflow(lhs: -Int64.max / 2, rhs: (-Int64.max / 2) - 1) == false) // No overflow: Beyond midpoint for negatives
            
            #expect(a.additionReportOverflow(lhs: 0, rhs: 0) == false) // No overflow: 0 + 0 = 0
            #expect(a.additionReportOverflow(lhs: 1, rhs: -1) == false) // No overflow: Opposite signs cancel out
            #expect(a.additionReportOverflow(lhs: Int64.min, rhs: Int64.max) == false) // No overflow: Int64.min + Int64.max = -1
            
            // Unsigned
            #expect(a.additionReportOverflow(lhs: UInt64.max, rhs: 1) == true) // Overflow: UInt64.max + 1 > UInt64.max
            #expect(a.additionReportOverflow(lhs: UInt64.max, rhs: 0) == false) // No overflow: UInt64.max + 0 = UInt64.max
            #expect(a.additionReportOverflow(lhs: UInt64.max - 1, rhs: 1) == false) // No overflow: UInt64.max - 1 + 1 = UInt64.max
            
            #expect(a.additionReportOverflow(lhs: 0, rhs: UInt64.max) == false) // No overflow: 0 + UInt64.max = UInt64.max
            #expect(a.additionReportOverflow(lhs: 1, rhs: UInt64.max - 1) == false) // No overflow: 1 + (UInt64.max - 1) = UInt64.max
            #expect(a.additionReportOverflow(lhs: UInt64.max / 2, rhs: UInt64.max / 2) == false) // No overflow: Midpoint addition
            #expect(a.additionReportOverflow(lhs: UInt64.max / 2, rhs: UInt64.max / 2 + 1) == false) // Overflow: Beyond midpoint addition
            
            #expect(a.additionReportOverflow(lhs: 0, rhs: 0) == false) // No overflow: 0 + 0 = 0
            #expect(a.additionReportOverflow(lhs: 1, rhs: 0) == false) // No overflow: 1 + 0 = 1
            #expect(a.additionReportOverflow(lhs: 0, rhs: UInt64.max) == false) // No overflow: 0 + UInt64.max = UInt64.max
            
            // Mixed
            // Test cases for signed integers
            #expect(a.additionReportOverflow(lhs: Int64.max - 1, rhs: 2) == true) // Positive overflow: adding 2 to max value
            #expect(a.additionReportOverflow(lhs: Int64.min + 1, rhs: -2) == true) // Negative overflow: subtracting 2 from min value
            #expect(a.additionReportOverflow(lhs: Int64.max, rhs: 1) == true)      // Positive overflow: adding 1 to max value
            #expect(a.additionReportOverflow(lhs: Int64.min, rhs: -1) == true)     // Negative overflow: subtracting 1 from min value
            #expect(a.additionReportOverflow(lhs: Int64.max / 2, rhs: Int64.max / 2 + 1) == false)
            #expect(a.additionReportOverflow(lhs: Int64.min / 2, rhs: -Int64.max / 2 - 1) == false)
            #expect(a.additionReportOverflow(lhs: Int64.max / 2, rhs: -Int64.max / 2) == false) // No overflow: valid negative sum
            
            // Test cases for mixed positive and negative signed integers
            #expect(a.additionReportOverflow(lhs: Int64.max / 2, rhs: -Int64.max / 2) == false) // No overflow: valid addition of positive and negative
            #expect(a.additionReportOverflow(lhs: Int64.max / 2, rhs: -Int64.max) == false)
            #expect(a.additionReportOverflow(lhs: Int64.min, rhs: Int64.max) == false)
            
            // Test cases for unsigned integers
            #expect(a.additionReportOverflow(lhs: UInt64.max / 2, rhs: UInt64.max / 2 + 1) == false) // No overflow: addition within valid range
            #expect(a.additionReportOverflow(lhs: UInt64.max, rhs: 1) == true)  // Overflow for unsigned: adding 1 to max value
            #expect(a.additionReportOverflow(lhs: UInt64.max - 1, rhs: 2) == true)  // Overflow for unsigned: adding 2 to near max value
            #expect(a.additionReportOverflow(lhs: 0, rhs: UInt64.max) == false)  // No overflow: zero + max value is valid
            
            // Test boundary conditions (adding zero)
            #expect(a.additionReportOverflow(lhs: Int64.max, rhs: 0) == false)  // No overflow: adding zero to max
            #expect(a.additionReportOverflow(lhs: Int64.min, rhs: 0) == false)  // No overflow: adding zero to min
            #expect(a.additionReportOverflow(lhs: UInt64.max, rhs: 0) == false) // No overflow: adding zero to unsigned max
            
            // Test adding zero to other values
            #expect(a.additionReportOverflow(lhs: Int64.max / 2, rhs: 0) == false)  // No overflow: adding zero to valid number
            #expect(a.additionReportOverflow(lhs: Int64.min / 2, rhs: 0) == false)  // No overflow: adding zero to valid negative number
            #expect(a.additionReportOverflow(lhs: UInt64.max / 2, rhs: 0) == false) // No overflow: adding zero to unsigned number
            
            // Test special case where rhs is the same magnitude as lhs but different signs
            #expect(a.additionReportOverflow(lhs: Int64.max / 2, rhs: -Int64.max / 2) == false) // No overflow: lhs + rhs sums to zero
        }
    }
    
    @Test func subtractionReportOverflow_Tests() {
        if let a = CustomInteger(for: 64) {
            // Signed Integer Test Cases
            
            // Test Case 1: Positive Overflow
            #expect(a.subtractionReportOverflow(lhs: Int64.max, rhs: -1) == true)  // Overflow: Result exceeds Int64.max
            
            // Test Case 2: Negative Overflow
            #expect(a.subtractionReportOverflow(lhs: Int64.min, rhs: 1) == true)  // Overflow: Result exceeds Int64.min
            
            // Test Case 3: No Overflow (Same Signs)
            #expect(a.subtractionReportOverflow(lhs: 100, rhs: 50) == false)  // No overflow
            
            // Test Case 4: No Overflow (Opposite Signs)
            #expect(a.subtractionReportOverflow(lhs: -100, rhs: 50) == false)  // No overflow
            
            // Test Case 5: Negative Overflow (Beyond Lower Bound)
            #expect(a.subtractionReportOverflow(lhs: Int64.min, rhs: Int64.max) == true)  // Overflow: Result goes below Int64.min
            
            // Test Case 6: Positive Overflow (Beyond Upper Bound)
            #expect(a.subtractionReportOverflow(lhs: Int64.max, rhs: Int64.min) == true)  // Overflow: Result goes above Int64.max
            
            // Test Case 7: No Overflow (Valid Subtraction)
            #expect(a.subtractionReportOverflow(lhs: 100, rhs: -50) == false)  // No overflow
            
            
            // Unsigned Integer Test Cases
            
            // Test Case 1: Overflow (Negative Result)
            #expect(a.subtractionReportOverflow(lhs: 10 as UInt64, rhs: 20 as UInt64) == true)  // Overflow: Negative result
            
            // Test Case 2: No Overflow (Valid Subtraction)
            #expect(a.subtractionReportOverflow(lhs: 100 as UInt64, rhs: 50 as UInt64) == false)  // No overflow
            
            // Test Case 3: No Overflow (Zero Result)
            #expect(a.subtractionReportOverflow(lhs: 50 as UInt64, rhs: 50 as UInt64) == false)  // No overflow
            
            
            // Edge Case Tests
            
            // Test Case 1: Maximum Possible Subtraction
            #expect(a.subtractionReportOverflow(lhs: Int64.max, rhs: Int64.min) == true)  // Overflow: Result exceeds Int64.max
            
            // Test Case 2: Minimum Possible Subtraction
            #expect(a.subtractionReportOverflow(lhs: Int64.min, rhs: Int64.max) == true)  // Overflow: Result exceeds Int64.min
        }
    }
    
    @Test func remainderReportOverflow_Tests() {
        if let a = CustomInteger(for: 64) {
            #expect(a.remainderReportOverflow(lhs: 0, rhs: 0) == true)              // Division by zero
            #expect(a.remainderReportOverflow(lhs: 1, rhs: 0) == true)              // Division by zero
            #expect(a.remainderReportOverflow(lhs: Int.max, rhs: 0) == true)        // Division by zero
            #expect(a.remainderReportOverflow(lhs: Int.min, rhs: -1) == true)       // Overflow: min / -1
            #expect(a.remainderReportOverflow(lhs: Int.max, rhs: -1) == false)      // No overflow
            #expect(a.remainderReportOverflow(lhs: 10, rhs: 2) == false)            // Valid division
            #expect(a.remainderReportOverflow(lhs: -10, rhs: 3) == false)           // Valid division
            #expect(a.remainderReportOverflow(lhs: Int.max, rhs: 1) == false)       // Valid division
            #expect(a.remainderReportOverflow(lhs: Int.min, rhs: 2) == false)       // Valid division
            #expect(a.remainderReportOverflow(lhs: UInt.max, rhs: 0) == true)       // Division by zero
            #expect(a.remainderReportOverflow(lhs: 10 as UInt, rhs: 2) == false)    // Valid division
            #expect(a.remainderReportOverflow(lhs: Int.min, rhs: Int.max) == false) // Valid division
            #expect(a.remainderReportOverflow(lhs: Int.max, rhs: Int.min) == false) // Valid division
            #expect(a.remainderReportOverflow(lhs: Int.min, rhs: 1) == false)       // Valid division
            #expect(a.remainderReportOverflow(lhs: UInt.max, rhs: 1) == false)      // Valid division
            #expect(a.remainderReportOverflow(lhs: UInt.max, rhs: UInt.max) == false) // Valid division
        }
    }
    
}
