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
            // Test cases for multiplication by zero
            #expect(a.multipliedReportingOverflow(lhs: 0, rhs: 0) == (0, false))  // 0 * 0
            #expect(a.multipliedReportingOverflow(lhs: 1, rhs: 0) == (0, false))  // 1 * 0
            #expect(a.multipliedReportingOverflow(lhs: 0, rhs: 1) == (0, false))  // 0 * 1
            #expect(a.multipliedReportingOverflow(lhs: -1, rhs: 0) == (0, false)) // -1 * 0
            
            // Test cases for positive multiplication
            #expect(a.multipliedReportingOverflow(lhs: 2, rhs: 3) == (6, false))  // 2 * 3 = 6
            #expect(a.multipliedReportingOverflow(lhs: Int64.max / 2, rhs: 2) == (Int64.max - 1, false))  // Maximum safe multiplication
            #expect(a.multipliedReportingOverflow(lhs: Int64.max, rhs: 2) == (-2, true))   // Overflow (Int64 max * 2)
            
            // Test cases for negative multiplication
            #expect(a.multipliedReportingOverflow(lhs: -2, rhs: -3) == (6, false))  // -2 * -3 = 6
            #expect(a.multipliedReportingOverflow(lhs: (Int64.min + 1) / 2, rhs: -2) == (-(Int64.min + 2), false))  // Maximum safe negative multiplication
            #expect(a.multipliedReportingOverflow(lhs: Int64.min, rhs: -2) == (0, true))   // Overflow (Int64 min * -2)
            
            // Test cases for boundary conditions
            #expect(a.multipliedReportingOverflow(lhs: Int64.max / 2, rhs: 2) == (Int64.max - 1, false))  // Safe for signed
            #expect(a.multipliedReportingOverflow(lhs: Int64.max / 2, rhs: 3) == (Int64.max / 2 &* 3, true))   // Overflow
            #expect(a.multipliedReportingOverflow(lhs: Int64.min / 2, rhs: 2) == (Int64.min, false))  // Safe for signed
            #expect(a.multipliedReportingOverflow(lhs: Int64.min / 2, rhs: 3) == (Int64.min / 2 &* 3, true))   // Overflow
            
            // Test cases for unsigned integers
            #expect(a.multipliedReportingOverflow(lhs: UInt64(UInt64.max / 2), rhs: 2) == (UInt64.max - 1, false))  // Safe multiplication for unsigned
            #expect(a.multipliedReportingOverflow(lhs: UInt64(UInt64.max / 2), rhs: 3) == (UInt64.max / 2 &* 3, true))   // Overflow
            #expect(a.multipliedReportingOverflow(lhs: UInt64.max, rhs: 2) == (UInt64.max &* 2, true))  // Overflow (UInt64 max * 2)
            
            // Test cases for special edge cases
            #expect(a.multipliedReportingOverflow(lhs: Int64.max, rhs: 1) == (Int64.max, false)) // Max signed * 1
            #expect(a.multipliedReportingOverflow(lhs: Int64.max, rhs: 2) == (-2, true))  // Max signed * 2 (Overflow)
            #expect(a.multipliedReportingOverflow(lhs: Int64.min, rhs: -1) == (Int64.min, true)) // Min signed * -1 (Overflow)
            #expect(a.multipliedReportingOverflow(lhs: UInt64.max, rhs: 2) == (UInt64.max &* 2, true)) // Max unsigned * 2 (Overflow)
        }
        
    }
    
    @Test func addingReportingOverflow_Tests() {

        if let a = CustomInteger(for: 64) {
            // Signed Integer Tests
            // Test 1: Negative overflow beyond lower bound
            #expect(a.addingReportingOverflow(lhs: -1 as Int64, rhs: -Int64.max) == (-9223372036854775808, false))
            
            // Test 2: Overflow due to adding negative values
            #expect(a.addingReportingOverflow(lhs: -Int64.max / 2, rhs: -Int64.max / 2 - 1) == (-9223372036854775807, false))
            
            // Test 3: Positive overflow
            #expect(a.addingReportingOverflow(lhs: Int64.max, rhs: 1) == (-9223372036854775808, true))
            
            // Test 4: Negative underflow
            #expect(a.addingReportingOverflow(lhs: Int64.min, rhs: -1) == (9223372036854775807, true))
            
            // Test 5: No overflow (midpoint addition)
            #expect(a.addingReportingOverflow(lhs: Int64.max / 2, rhs: Int64.max / 2) == (9223372036854775806, false))
            
            // Test 6: No overflow (edge case addition)
            #expect(a.addingReportingOverflow(lhs: Int64.min / 2, rhs: (-Int64.max - 1) / 2) == (-9223372036854775808, false))
            
            // Test 7: No overflow (adding zero to min)
            #expect(a.addingReportingOverflow(lhs: Int64.min, rhs: 0) == (-9223372036854775808, false))
            
            // Test 8: No overflow (adding 1 to min)
            #expect(a.addingReportingOverflow(lhs: Int64.min, rhs: 1) == (-9223372036854775807, false))
            
            // Test 9: No overflow (adding zero to max)
            #expect(a.addingReportingOverflow(lhs: Int64.max, rhs: 0) == (9223372036854775807, false))
            
            // Test 10: No overflow (subtracting 1 from max)
            #expect(a.addingReportingOverflow(lhs: Int64.max, rhs: -1) == (9223372036854775806, false))
            
            // Test 11: Negative overflow (edge case)
            #expect(a.addingReportingOverflow(lhs: -1, rhs: -Int64.max) == (-9223372036854775808, false))
            
            // Test 12: No overflow (edge case addition)
            #expect(a.addingReportingOverflow(lhs: Int64.max / 2, rhs: Int64.max / 2 + 1) == (9223372036854775807, false))
            
            // Test 13: No overflow (midpoint addition for negatives)
            #expect(a.addingReportingOverflow(lhs: -Int64.max / 2, rhs: -Int64.max / 2) == (-9223372036854775806, false))
            
            // Test 14: No overflow (beyond midpoint for negatives)
            #expect(a.addingReportingOverflow(lhs: -Int64.max / 2, rhs: (-Int64.max / 2) - 1) == (-9223372036854775807, false))
            
            // Test 15: No overflow (adding zero to zero)
            #expect(a.addingReportingOverflow(lhs: 0, rhs: 0) == (0, false))
            
            // Test 16: No overflow (opposite signs cancel out)
            #expect(a.addingReportingOverflow(lhs: 1, rhs: -1) == (0, false))
            
            // Test 17: No overflow (Int64.min + Int64.max = -1)
            #expect(a.addingReportingOverflow(lhs: Int64.min, rhs: Int64.max) == (-1, false))
            
            // Unsigned Integer Tests
            // Test 18: Overflow (UInt64.max + 1)
            #expect(a.addingReportingOverflow(lhs: UInt64.max, rhs: 1) == (0, true))
            
            // Test 19: No overflow (UInt64.max + 0)
            #expect(a.addingReportingOverflow(lhs: UInt64.max, rhs: 0) == (18446744073709551615, false))
            
            // Test 20: No overflow (UInt64.max - 1 + 1)
            #expect(a.addingReportingOverflow(lhs: UInt64.max - 1, rhs: 1) == (18446744073709551615, false))
            
            // Test 21: No overflow (0 + UInt64.max)
            #expect(a.addingReportingOverflow(lhs: 0, rhs: UInt64.max) == (18446744073709551615, false))
            
            // Test 22: No overflow (1 + (UInt64.max - 1))
            #expect(a.addingReportingOverflow(lhs: 1, rhs: UInt64.max - 1) == (18446744073709551615, false))
            
            // Test 23: No overflow (midpoint addition)
            #expect(a.addingReportingOverflow(lhs: UInt64.max / 2, rhs: UInt64.max / 2) == (18446744073709551614, false))
            
            // Test 24: No overflow (edge case addition)
            #expect(a.addingReportingOverflow(lhs: UInt64.max / 2, rhs: UInt64.max / 2 + 1) == (18446744073709551615, false))
            
            // Test 25: No overflow (0 + 0)
            #expect(a.addingReportingOverflow(lhs: 0, rhs: 0) == (0, false))
            
            // Test 26: No overflow (1 + 0)
            #expect(a.addingReportingOverflow(lhs: 1, rhs: 0) == (1, false))
            
            // Test 27: No overflow (0 + UInt64.max)
            #expect(a.addingReportingOverflow(lhs: 0, rhs: UInt64.max) == (18446744073709551615, false))
            
            // Mixed Tests
            // Test 28: Positive overflow (Int64.max - 1 + 2)
            #expect(a.addingReportingOverflow(lhs: Int64.max - 1, rhs: 2) == (-9223372036854775808, true))
            
            // Test 29: Negative overflow (Int64.min + 1 - 2)
            #expect(a.addingReportingOverflow(lhs: Int64.min + 1, rhs: -2) == (9223372036854775807, true))
            
            // Test 30: Positive overflow (Int64.max + 1)
            #expect(a.addingReportingOverflow(lhs: Int64.max, rhs: 1) == (-9223372036854775808, true))
            
            // Test 31: Negative overflow (Int64.min - 1)
            #expect(a.addingReportingOverflow(lhs: Int64.min, rhs: -1) == (9223372036854775807, true))
            
            // Test 32: No overflow (Int64.max / 2 + Int64.max / 2 + 1)
            #expect(a.addingReportingOverflow(lhs: Int64.max / 2, rhs: Int64.max / 2 + 1) == (9223372036854775807, false))
            
            // Test 33: No overflow (Int64.min / 2 + (-Int64.max / 2 - 1))
            #expect(a.addingReportingOverflow(lhs: Int64.min / 2, rhs: -Int64.max / 2 - 1) == (-9223372036854775808, false))
            
            // Test 34: No overflow (Int64.max / 2 + -Int64.max / 2)
            #expect(a.addingReportingOverflow(lhs: Int64.max / 2, rhs: -Int64.max / 2) == (0, false))
            
            // Test 35: No overflow (Int64.max / 2 + -Int64.max)
            #expect(a.addingReportingOverflow(lhs: Int64.max / 2, rhs: -Int64.max) == (-4611686018427387904, false))
            
            // Test 36: No overflow (Int64.min + Int64.max)
            #expect(a.addingReportingOverflow(lhs: Int64.min, rhs: Int64.max) == (-1, false))
            
            // Test 37: No overflow (UInt64.max / 2 + UInt64.max / 2 + 1)
            #expect(a.addingReportingOverflow(lhs: UInt64.max / 2, rhs: UInt64.max / 2 + 1) == (18446744073709551615, false))
            
            // Test 38: Overflow (UInt64.max + 1)
            #expect(a.addingReportingOverflow(lhs: UInt64.max, rhs: 1) == (0, true))
            
            // Test 39: Overflow (UInt64.max - 1 + 2)
            #expect(a.addingReportingOverflow(lhs: UInt64.max - 1, rhs: 2) == (0, true))
            
            // Test 40: No overflow (0 + UInt64.max)
            #expect(a.addingReportingOverflow(lhs: 0, rhs: UInt64.max) == (18446744073709551615, false))
            
            // Test 41: No overflow (Int64.max + 0)
            #expect(a.addingReportingOverflow(lhs: Int64.max, rhs: 0) == (9223372036854775807, false))
            
            // Test 42: No overflow (Int64.min + 0)
            #expect(a.addingReportingOverflow(lhs: Int64.min, rhs: 0) == (-9223372036854775808, false))
            
            // Test 43: No overflow (UInt64.max + 0)
            #expect(a.addingReportingOverflow(lhs: UInt64.max, rhs: 0) == (18446744073709551615, false))
            
            // Test 44: No overflow (Int64.max / 2 + 0)
            #expect(a.addingReportingOverflow(lhs: Int64.max / 2, rhs: 0) == (4611686018427387903, false))
            
            // Test 45: No overflow (Int64.min / 2 + 0)
            #expect(a.addingReportingOverflow(lhs: Int64.min / 2, rhs: 0) == (-4611686018427387904, false))
            
            // Test 46: No overflow (UInt64.max / 2 + 0)
            #expect(a.addingReportingOverflow(lhs: UInt64.max / 2, rhs: 0) == (9223372036854775807, false))
            
            // Test 47: No overflow (Int64.max / 2 + -Int64.max / 2)
            #expect(a.addingReportingOverflow(lhs: Int64.max / 2, rhs: -Int64.max / 2) == (0, false))
        }
    }
    
    @Test func subtractingReportingOverflow_Tests() {
        
        if let a = CustomInteger(for: 64) {
            // Signed Integer Test Cases
            
            // Test Case 1: Positive Overflow
            #expect(a.subtractingReportingOverflow(lhs: Int64.max, rhs: -1) == (Int64.max &- (-1), true))  // Overflow: Result exceeds Int64.max
            
            // Test Case 2: Negative Overflow
            #expect(a.subtractingReportingOverflow(lhs: Int64.min, rhs: 1) == (Int64.min &- 1, true))  // Overflow: Result exceeds Int64.min
            
            // Test Case 3: No Overflow (Same Signs, Positive)
            #expect(a.subtractingReportingOverflow(lhs: 100, rhs: 50) == (100 - 50, false))  // No overflow
            
            // Test Case 4: No Overflow (Same Signs, Negative)
            #expect(a.subtractingReportingOverflow(lhs: -100, rhs: -50) == (-100 - (-50), false))  // No overflow
            
            // Test Case 5: No Overflow (Opposite Signs)
            #expect(a.subtractingReportingOverflow(lhs: -100, rhs: 50) == (-100 - 50, false))  // No overflow
            
            // Test Case 6: Negative Overflow (Beyond Lower Bound)
            #expect(a.subtractingReportingOverflow(lhs: Int64.min, rhs: Int64.max) == (Int64.min &- Int64.max, true))  // Overflow: Result goes below Int64.min
            
            // Test Case 7: Positive Overflow (Beyond Upper Bound)
            #expect(a.subtractingReportingOverflow(lhs: Int64.max, rhs: Int64.min) == (Int64.max &- Int64.min, true))  // Overflow: Result goes above Int64.max
            
            // Test Case 8: No Overflow (Valid Subtraction, Opposite Signs)
            #expect(a.subtractingReportingOverflow(lhs: 100, rhs: -50) == (100 - (-50), false))  // No overflow
            
            // Test Case 9: Edge Case (Zero Subtraction)
            #expect(a.subtractingReportingOverflow(lhs: 0, rhs: 0) == (0, false))  // No overflow
            
            // Test Case 10: Edge Case (Subtracting Zero)
            #expect(a.subtractingReportingOverflow(lhs: Int64.max, rhs: 0) == (Int64.max, false))  // No overflow
            
            // Test Case 11: Edge Case (Subtracting Zero from Minimum)
            #expect(a.subtractingReportingOverflow(lhs: Int64.min, rhs: 0) == (Int64.min, false))  // No overflow
            
            // Test Case 12: Edge Case (Subtracting Maximum from Maximum)
            #expect(a.subtractingReportingOverflow(lhs: Int64.max, rhs: Int64.max) == (Int64.max &- Int64.max, false))  // No overflow
            
            // Test Case 13: Edge Case (Subtracting Minimum from Minimum)
            #expect(a.subtractingReportingOverflow(lhs: Int64.min, rhs: Int64.min) == (Int64.min &- Int64.min, false))  // No overflow
            
            // Unsigned Integer Test Cases
            
            // Test Case 1: Overflow (Negative Result)
            #expect(a.subtractingReportingOverflow(lhs: UInt64(10), rhs: UInt64(20)) == (UInt64(10) &- UInt64(20), true))  // Overflow: Negative result
            
            // Test Case 2: No Overflow (Valid Subtraction)
            #expect(a.subtractingReportingOverflow(lhs: UInt64(100), rhs: UInt64(50)) == (UInt64(100) - UInt64(50), false))  // No overflow
            
            // Test Case 3: No Overflow (Zero Result)
            #expect(a.subtractingReportingOverflow(lhs: UInt64(50), rhs: UInt64(50)) == (UInt64(50) - UInt64(50), false))  // No overflow
            
            // Test Case 4: Edge Case (Subtracting Zero)
            #expect(a.subtractingReportingOverflow(lhs: UInt64.max, rhs: UInt64(0)) == (UInt64.max, false))  // No overflow
            
            // Test Case 5: Edge Case (Subtracting Maximum from Maximum)
            #expect(a.subtractingReportingOverflow(lhs: UInt64.max, rhs: UInt64.max) == (UInt64.max &- UInt64.max, false))  // No overflow
            
            // Test Case 6: Edge Case (Subtracting One from Zero)
            #expect(a.subtractingReportingOverflow(lhs: UInt64(0), rhs: UInt64(1)) == (UInt64(0) &- UInt64(1), true))  // Overflow: Negative result
            
            // Edge Case Tests
            
            // Test Case 1: Maximum Possible Subtraction (Signed)
            #expect(a.subtractingReportingOverflow(lhs: Int64.max, rhs: Int64.min) == (Int64.max &- Int64.min, true))  // Overflow: Result exceeds Int64.max
            
            // Test Case 2: Minimum Possible Subtraction (Signed)
            #expect(a.subtractingReportingOverflow(lhs: Int64.min, rhs: Int64.max) == (Int64.min &- Int64.max, true))  // Overflow: Result exceeds Int64.min
            
            // Test Case 3: Maximum Possible Subtraction (Unsigned)
            #expect(a.subtractingReportingOverflow(lhs: UInt64.max, rhs: UInt64.min) == (UInt64.max &- UInt64.min, false))  // No overflow
            
            // Test Case 4: Minimum Possible Subtraction (Unsigned)
            #expect(a.subtractingReportingOverflow(lhs: UInt64.min, rhs: UInt64.max) == (UInt64.min &- UInt64.max, true))  // Overflow: Negative result
        }
        
    }
    
    @Test func dividedReportingOverflow_Tests() {
        
        if let a = CustomInteger(for: 64) {
            // Division by zero (signed)
            #expect(a.dividedReportingOverflow(lhs: 0, rhs: 0) == (0, true), "Division by zero should return (0, true)")
            #expect(a.dividedReportingOverflow(lhs: 1, rhs: 0) == (0, true), "Division by zero should return (0, true)")
            #expect(a.dividedReportingOverflow(lhs: -1, rhs: 0) == (0, true), "Division by zero should return (0, true)")
            
            // Normal division (signed)
            #expect(a.dividedReportingOverflow(lhs: Int64.max, rhs: 1) == (Int64.max, false), "Int64.max / 1 should return (Int64.max, false)")
            #expect(a.dividedReportingOverflow(lhs: Int64.min, rhs: 1) == (Int64.min, false), "Int64.min / 1 should return (Int64.min, false)")
            #expect(a.dividedReportingOverflow(lhs: 0, rhs: 1) == (0, false), "0 / 1 should return (0, false)")
            #expect(a.dividedReportingOverflow(lhs: 100, rhs: 2) == (50, false), "100 / 2 should return (50, false)")
            
            // Overflow for signed integers (Int64.min / -1)
            #expect(a.dividedReportingOverflow(lhs: Int64.min, rhs: -1) == (Int64.min, true), "Int64.min / -1 should overflow")
            
            // Edge cases (signed)
            #expect(a.dividedReportingOverflow(lhs: Int64.min, rhs: 2) == (Int64.min / 2, false), "Int64.min / 2 should return (Int64.min / 2, false)")
            #expect(a.dividedReportingOverflow(lhs: Int64.max, rhs: -1) == (-Int64.max, false), "Int64.max / -1 should return (-Int64.max, false)")
            #expect(a.dividedReportingOverflow(lhs: Int64.max, rhs: -2) == (Int64.max / -2, false), "Int64.max / -2 should return (Int64.max / -2, false)")
            #expect(a.dividedReportingOverflow(lhs: -10, rhs: -2) == (5, false), "-10 / -2 should return (5, false)")
            
            // Division with same values (signed)
            #expect(a.dividedReportingOverflow(lhs: Int64.max, rhs: Int64.max) == (1, false), "Int64.max / Int64.max should return (1, false)")
            #expect(a.dividedReportingOverflow(lhs: Int64.min, rhs: Int64.min) == (1, false), "Int64.min / Int64.min should return (1, false)")
            #expect(a.dividedReportingOverflow(lhs: 1, rhs: 1) == (1, false), "1 / 1 should return (1, false)")
            #expect(a.dividedReportingOverflow(lhs: 100, rhs: 100) == (1, false), "100 / 100 should return (1, false)")
            
            // Safe division near Int64.min (signed)
            #expect(a.dividedReportingOverflow(lhs: Int64.min + 1, rhs: -1) == (-(Int64.min + 1), false), "(Int64.min + 1) / -1 should return (-(Int64.min + 1), false)")
            #expect(a.dividedReportingOverflow(lhs: Int64.min + 2, rhs: -1) == (-(Int64.min + 2), false), "(Int64.min + 2) / -1 should return (-(Int64.min + 2), false)")
            
            // Safe division within range (signed)
            #expect(a.dividedReportingOverflow(lhs: Int64.max / 2, rhs: 2) == (Int64.max / 4, false), "(Int64.max / 2) / 2 should return (Int64.max / 4, false)")
            
            // Division by zero (unsigned)
            #expect(a.dividedReportingOverflow(lhs: UInt64(0), rhs: UInt64(0)) == (0, true), "0 / 0 should return (0, true)")
            #expect(a.dividedReportingOverflow(lhs: UInt64(1), rhs: UInt64(0)) == (0, true), "1 / 0 should return (0, true)")
            #expect(a.dividedReportingOverflow(lhs: UInt64(100), rhs: UInt64(0)) == (0, true), "100 / 0 should return (0, true)")
            
            // Normal division (unsigned)
            #expect(a.dividedReportingOverflow(lhs: UInt64.max, rhs: UInt64(1)) == (UInt64.max, false), "UInt64.max / 1 should return (UInt64.max, false)")
            #expect(a.dividedReportingOverflow(lhs: UInt64.min, rhs: UInt64(1)) == (UInt64.min, false), "UInt64.min / 1 should return (UInt64.min, false)")
            #expect(a.dividedReportingOverflow(lhs: UInt64(0), rhs: UInt64(1)) == (0, false), "0 / 1 should return (0, false)")
            #expect(a.dividedReportingOverflow(lhs: UInt64(100), rhs: UInt64(2)) == (50, false), "100 / 2 should return (50, false)")
            
            // Division with same values (unsigned)
            #expect(a.dividedReportingOverflow(lhs: UInt64.max, rhs: UInt64.max) == (1, false), "UInt64.max / UInt64.max should return (1, false)")
            #expect(a.dividedReportingOverflow(lhs: UInt64(1), rhs: UInt64.max) == (0, false), "1 / UInt64.max should return (0, false)")
            #expect(a.dividedReportingOverflow(lhs: UInt64(100), rhs: UInt64(200)) == (0, false), "100 / 200 should return (0, false)")
            #expect(a.dividedReportingOverflow(lhs: UInt64.min, rhs: UInt64.min) == (0, true), "0 / 0 should return (0, true)")
        }
        
        for bit in Int64(1)...Int64(64) {
            if let a = CustomInteger(for: bit) {
                let sMin = a.ranges.signed.lowerBound
                let sMax = a.ranges.signed.upperBound
                let uMin = a.ranges.unsigned.lowerBound
                let uMax = a.ranges.unsigned.upperBound
                
//                print("Testing bit width: \(bit), signed range: \(sMin)...\(sMax), unsigned range: \(uMin)...\(uMax)")
                
                switch bit {
                    case 1:
                        // 1-bit integers (signed: -1, 0; unsigned: 0, 1)
                        #expect(a.dividedReportingOverflow(lhs: 0, rhs: 0) == (0, true), "0 / 0 should return (0, true)")
                        #expect(a.dividedReportingOverflow(lhs: 1, rhs: 0) == (0, true), "1 / 0 should return (0, true)")
                        #expect(a.dividedReportingOverflow(lhs: -1, rhs: 0) == (0, true), "-1 / 0 should return (0, true)")
                        
                        #expect(a.dividedReportingOverflow(lhs: uMax, rhs: 1) == (uMax, false), "uMax / 1 should return (uMax, false)")
                        
                    case 2:
                        // 2-bit integers (signed: -2, -1, 0, 1; unsigned: 0, 1, 2, 3)
                        #expect(a.dividedReportingOverflow(lhs: sMin, rhs: -1) == (sMin, true), "sMin / -1 should overflow")
                        #expect(a.dividedReportingOverflow(lhs: sMax, rhs: -1) == (-sMax, false), "sMax / -1 should return (-sMax, false)")
                        
                        #expect(a.dividedReportingOverflow(lhs: sMax, rhs: 2) == (sMax / 2, false), "sMax / 2 should return (sMax / 2, false)")
                        #expect(a.dividedReportingOverflow(lhs: uMax, rhs: 2) == (uMax / 2, false), "uMax / 2 should return (uMax / 2, false)")
                        
                    case 3...Int64.max:
                        // 3-bit and higher integers
                        // Division by zero (signed and unsigned)
                        #expect(a.dividedReportingOverflow(lhs: 0, rhs: 0) == (0, true), "0 / 0 should return (0, true)")
                        #expect(a.dividedReportingOverflow(lhs: 1, rhs: 0) == (0, true), "1 / 0 should return (0, true)")
                        #expect(a.dividedReportingOverflow(lhs: -1, rhs: 0) == (0, true), "-1 / 0 should return (0, true)")
                        #expect(a.dividedReportingOverflow(lhs: uMin, rhs: 0) == (0, true), "uMin / 0 should return (0, true)")
                        #expect(a.dividedReportingOverflow(lhs: uMax, rhs: 0) == (0, true), "uMax / 0 should return (0, true)")
                        
                        // Normal division (signed)
                        #expect(a.dividedReportingOverflow(lhs: sMax, rhs: 1) == (sMax, false), "sMax / 1 should return (sMax, false)")
                        #expect(a.dividedReportingOverflow(lhs: sMin, rhs: 1) == (sMin, false), "sMin / 1 should return (sMin, false)")
                        #expect(a.dividedReportingOverflow(lhs: 0, rhs: 1) == (0, false), "0 / 1 should return (0, false)")
                        #expect(a.dividedReportingOverflow(lhs: 100, rhs: 2) == (50, false), "100 / 2 should return (50, false)")
                        
                        // Overflow for signed integers (sMin / -1)
                        #expect(a.dividedReportingOverflow(lhs: sMin, rhs: -1) == (sMin, true), "sMin / -1 should overflow")
                        
                        // Edge cases (signed)
                        #expect(a.dividedReportingOverflow(lhs: sMin, rhs: 2) == (sMin / 2, false), "sMin / 2 should return (sMin / 2, false)")
                        #expect(a.dividedReportingOverflow(lhs: sMax, rhs: -1) == (-sMax, false), "sMax / -1 should return (-sMax, false)")
                        #expect(a.dividedReportingOverflow(lhs: sMax, rhs: -2) == (sMax / -2, false), "sMax / -2 should return (sMax / -2, false)")
                        #expect(a.dividedReportingOverflow(lhs: -10, rhs: -2) == (5, false), "-10 / -2 should return (5, false)")
                        
                        // Division with same values (signed)
                        #expect(a.dividedReportingOverflow(lhs: sMax, rhs: sMax) == (1, false), "sMax / sMax should return (1, false)")
                        #expect(a.dividedReportingOverflow(lhs: sMin, rhs: sMin) == (1, false), "sMin / sMin should return (1, false)")
                        #expect(a.dividedReportingOverflow(lhs: 1, rhs: 1) == (1, false), "1 / 1 should return (1, false)")
                        #expect(a.dividedReportingOverflow(lhs: 100, rhs: 100) == (1, false), "100 / 100 should return (1, false)")
                        
                        // Safe division near sMin (signed)
                        #expect(a.dividedReportingOverflow(lhs: sMin + 1, rhs: -1) == (-(sMin + 1), false), "(sMin + 1) / -1 should return (-(sMin + 1), false)")
                        #expect(a.dividedReportingOverflow(lhs: sMin + 2, rhs: -1) == (-(sMin + 2), false), "(sMin + 2) / -1 should return (-(sMin + 2), false)")
                        
                        // Safe division within range (signed)
                        #expect(a.dividedReportingOverflow(lhs: sMax / 2, rhs: 2) == (sMax / 4, false), "(sMax / 2) / 2 should return (sMax / 4, false)")
                        
                        // Normal division (unsigned)
                        #expect(a.dividedReportingOverflow(lhs: uMax, rhs: 1) == (uMax, false), "uMax / 1 should return (uMax, false)")
                        #expect(a.dividedReportingOverflow(lhs: uMin, rhs: 1) == (uMin, false), "uMin / 1 should return (uMin, false)")
                        #expect(a.dividedReportingOverflow(lhs: 100, rhs: 2) == (50, false), "100 / 2 should return (50, false)")
                        
                        // Division with same values (unsigned)
                        #expect(a.dividedReportingOverflow(lhs: uMax, rhs: uMax) == (1, false), "uMax / uMax should return (1, false)")
                        #expect(a.dividedReportingOverflow(lhs: 1, rhs: uMax) == (0, false), "1 / uMax should return (0, false)")
                        #expect(a.dividedReportingOverflow(lhs: 100, rhs: 200) == (0, false), "100 / 200 should return (0, false)")
                        
                    default:
                        break
                }
            }
        }
        
    }
    
    @Test func remainderReportingOverflow_Tests() {
        
        for bit in Int64(1)...Int64(64) {
            if let a = CustomInteger(for: bit) {
                let sMin = a.ranges.signed.lowerBound
                let sMax = a.ranges.signed.upperBound
                let uMin = a.ranges.unsigned.lowerBound
                let uMax = a.ranges.unsigned.upperBound
                
//                print("Testing bit width: \(bit), signed range: \(sMin)...\(sMax), unsigned range: \(uMin)...\(uMax)")
                
                switch bit {
                    case 1:
                        // 1-bit integers (signed: -1, 0; unsigned: 0, 1)
                        #expect(a.remainderReportingOverflow(lhs: sMin, rhs: 0) == (0, true))  // sMin % 0 (division by zero)
                        #expect(a.remainderReportingOverflow(lhs: sMax, rhs: 0) == (0, true))  // sMax % 0 (division by zero)
                        #expect(a.remainderReportingOverflow(lhs: uMin, rhs: 0) == (0, true))  // uMin % 0 (division by zero)
                        #expect(a.remainderReportingOverflow(lhs: uMax, rhs: 0) == (0, true))  // uMax % 0 (division by zero)
                        
                        #expect(a.remainderReportingOverflow(lhs: uMax, rhs: 2) == (uMax % 2, false))  // uMax % 2
                        
                    case 2:
                        // 2-bit integers (signed: -2, -1, 0, 1; unsigned: 0, 1, 2, 3)
                        #expect(a.remainderReportingOverflow(lhs: sMin, rhs: -1) == (0, true))  // sMin % -1 (overflow)
                        #expect(a.remainderReportingOverflow(lhs: sMax, rhs: -1) == (0, false)) // sMax % -1 (no overflow)
                        
                        #expect(a.remainderReportingOverflow(lhs: sMax, rhs: 2) == (sMax % 2, false))  // sMax % 2
                        #expect(a.remainderReportingOverflow(lhs: uMax, rhs: 2) == (uMax % 2, false))  // uMax % 2
                        
                    case 3...Int64.max:
                        // 3-bit and higher integers
                        // Test intermediate values
                        let midSigned = sMin / 2 + sMax / 2
                        let midUnsigned = uMin / 2 + uMax / 2
                        
                        #expect(a.remainderReportingOverflow(lhs: midSigned, rhs: 2) == (midSigned % 2, false))  // midSigned % 2
                        #expect(a.remainderReportingOverflow(lhs: midUnsigned, rhs: 2) == (midUnsigned % 2, false))  // midUnsigned % 2
                        
                        // Test values just above/below the minimum and maximum
                        #expect(a.remainderReportingOverflow(lhs: sMin + 1, rhs: 2) == ((sMin + 1) % 2, false))  // (sMin + 1) % 2
                        #expect(a.remainderReportingOverflow(lhs: sMax - 1, rhs: 2) == ((sMax - 1) % 2, false))  // (sMax - 1) % 2
                        #expect(a.remainderReportingOverflow(lhs: uMin + 1, rhs: 2) == ((uMin + 1) % 2, false))  // (uMin + 1) % 2
                        #expect(a.remainderReportingOverflow(lhs: uMax - 1, rhs: 2) == ((uMax - 1) % 2, false))  // (uMax - 1) % 2
                        
                        // Test division by zero
                        #expect(a.remainderReportingOverflow(lhs: sMin, rhs: 0) == (0, true))  // sMin % 0 (division by zero)
                        #expect(a.remainderReportingOverflow(lhs: sMax, rhs: 0) == (0, true))  // sMax % 0 (division by zero)
                        #expect(a.remainderReportingOverflow(lhs: uMin, rhs: 0) == (0, true))  // uMin % 0 (division by zero)
                        #expect(a.remainderReportingOverflow(lhs: uMax, rhs: 0) == (0, true))  // uMax % 0 (division by zero)
                        
                        // Test division by -1
                        #expect(a.remainderReportingOverflow(lhs: sMin, rhs: -1) == (0, true))  // sMin % -1 (overflow)
                        #expect(a.remainderReportingOverflow(lhs: sMax, rhs: -1) == (0, false)) // sMax % -1 (no overflow)
                        
                        // Test maximum value
                        #expect(a.remainderReportingOverflow(lhs: sMax, rhs: 2) == (sMax % 2, false))  // sMax % 2
                        #expect(a.remainderReportingOverflow(lhs: uMax, rhs: 2) == (uMax % 2, false))  // uMax % 2
                        
                    default:
                        break
                }
            }
        }
    }
    
}
