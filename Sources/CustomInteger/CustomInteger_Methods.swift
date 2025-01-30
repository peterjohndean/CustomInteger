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

extension CustomInteger {
    
    /// - Returns: true, if value `<<` by will result in a bitwise overflow.
    public func leftShiftReportingOverflow<T: BinaryInteger>(_ value: T, by shift: T) -> Bool {
        guard value != 0 && shift > 0 else {
            return false // No overflow
        }
        
        // Adjust bitWidth for signed or unsigned data types.
        let adjustedBitWidth = T.isSigned
        ? bitWidth &- 1  // Signed
        : bitWidth      // Unsigned
        
        return shift >= adjustedBitWidth /* Shifts >= bitWidth */ || (value >> (adjustedBitWidth &- Int(shift))) != 0 /* Shifts < bitWidth */
    }
    
    /* Integer Overflow Truth Tables
     
     `+`
        * Opposite signs, no overflow.
        |-----|-----|-------------------------|----------|-----------------------------------------------------------------------------------|
        | lhs | rhs | Overflow Condition      | Overflow | Explanation                                                                       |
        |-----|-----|-------------------------|----------|-----------------------------------------------------------------------------------|
        |  +  |  -  | N/A                     | No       | Opposite signs cannot overflow.                                                   |
        |  -  |  +  | N/A                     | No       | Opposite signs cannot overflow.                                                   |
        |-----|-----|-------------------------|----------|-----------------------------------------------------------------------------------|
        |  +  |  +  | If lhs > Int.max - rhs  | Yes      | Adding two positives might exceed the maximum representable value.                |
        |  -  |  -  | If lhs < Int.min - rhs  | Yes      | Adding two negatives might go below the minimum representable value.              |
        |-----|-----|-------------------------|----------|-----------------------------------------------------------------------------------|
        |  +  |  +  | If rhs > UInt.max - lhs | Yes      | Unsigned Only: Adding two positives might exceed the maximum representable value. |
        |-----|-----|-------------------------|----------|-----------------------------------------------------------------------------------|
     
     `-`
        * Same signs, no overflow.
        |-----|-----|------------------------|----------|------------------------------------------------------------------------------|
        | lhs | rhs | Overflow Condition     | Overflow | Explanation                                                                  |
        |-----|-----|------------------------|----------|------------------------------------------------------------------------------|
        |  +  |  +  | N/A                    | No       | Same signs cannot overflow.                                                  |
        |  -  |  -  | N/A                    | No       | Same signs cannot overflow.                                                  |
        |-----|-----|------------------------|----------|------------------------------------------------------------------------------|
        |  +  |  -  | If lhs > Int.max + rhs | Yes      | Positive minus negative might exceed the maximum representable value.        |
        |  -  |  +  | If lhs < Int.min + rhs | Yes      | Negative minus positive might go below the minimum representable value.      |
        |-----|-----|------------------------|----------|------------------------------------------------------------------------------|
        |  +  |  +  | If lhs < rhs           | Yes      | Unsigned Only: lhs < rhs causes underflow, which leads to overflow.          |
        |-----|-----|------------------------|----------|------------------------------------------------------------------------------|
     
     `*`
        |-----|-----|-------------------------|----------|------------------------------------------------------------------------------------------------------------|
        | lhs | rhs | Overflow Condition      | Overflow | Explanation                                                                                                |
        |-----|-----|-------------------------|----------|------------------------------------------------------------------------------------------------------------|
        |  +  |  +  | if lhs > Int.max / rhs  | Yes      | Multiplying two positives might exceed the maximum representable value.                                    |
        |  -  |  -  | if lhs < Int.max / rhs  | Yes      | Multiplying two negatives results in a positive value, which might exceed the maximum representable value. |
        |  +  |  -  | if lhs > Int.min / rhs  | Yes      | Multiplying a positive and a negative might go below the minimum representable value.                      |
        |  -  |  +  | if lhs < Int.min / rhs  | Yes      | Multiplying a negative and a positive might go below the minimum representable value.                      |
        |-----|-----|-------------------------|----------|------------------------------------------------------------------------------------------------------------|
        |  +  |  +  | if lhs > UInt.max / rhs | Yes      | Unsigned Only: Multiplying two positives might exceed the maximum representable value.                     |
        |-----|-----|-------------------------|----------|------------------------------------------------------------------------------------------------------------|
     
     `/`
     `%`
        |-----------|--------------------------------|-----------|
        | lhs | rhs | Overflow Condition             | Overflow? |
        |-----------|--------------------------------|-----------|
        |  ±  |  0  | rhs == 0                       | Yes       |
        |  -  |  -  | if lhs == Int.min && rhs == -1 | Yes       |
        |-----------|--------------------------------|-----------|
     */
    
    /// - Returns: A tuple containing the result of the addition along with a Boolean value indicating whether overflow occurred.
    public func addingReportingOverflow<T: BinaryInteger>(lhs: T, rhs: T) -> (partialValue: T, overflow: Bool) {
        if T.isSigned {
            // Overflow logic for signed integers
            let lhs = Int(lhs)
            let rhs = Int(rhs)
            
            let result = T(toSignedBitWidth(lhs &+ rhs))
            
            // Check for opposite signs, no risk of overflow
            guard (lhs ^ rhs) >= 0 else {
                return (result, false)
            }
            
            // Check for zero values, no risk of overflow
            guard lhs != 0 && rhs != 0 else {
                return (result, false)
            }
            
            // Check for positive overflow (same signs)
            if lhs > 0 && lhs > ranges.signed.upperBound &- rhs {
                return (result, true)
            } else
            // Check for negative overflow (same signs)
            if lhs < 0 && lhs < ranges.signed.lowerBound &- rhs {
                return (result, true)
            }
            
            // No overflow
            return (result, false)
            
        } else {
            // Overflow logic for unsigned integers
            let lhs = UInt(lhs)
            let rhs = UInt(rhs)
            
            // Check for positive overflow (only same signs ;) )
            if rhs > (ranges.unsigned.upperBound &- lhs) {
                return (0, true)
            } else {
                return (T(toUnsignedBitWidth(lhs &+ rhs)), false)
            }
        }
    }
    
    /// - Returns: A tuple containing the result of the subtraction along with a Boolean value indicating whether overflow occurred.
    public func subtractingReportingOverflow<T: BinaryInteger>(lhs: T, rhs: T) -> (partialValue: T, overflow: Bool) {
        if T.isSigned {
            // Overflow logic for signed integers
            let lhs = Int(lhs)
            let rhs = Int(rhs)
            
            let result = T(toSignedBitWidth(lhs &- rhs))
            
            // Check for same signs, no risk of overflow
            guard (lhs ^ rhs) < 0 else {
                return (result, false)
            }
            
            // Check for zero values, no risk of overflow
            guard rhs != 0 else {
                return (result, false)
            }
            
            // Check for positive overflow (opposite signs)
            if (lhs > 0 && lhs > ranges.signed.upperBound &+ rhs) {
                return (result, true)
            } else
            // Check for negative overflow (opposit signs)
            if (lhs < 0 && lhs < ranges.signed.lowerBound &+ rhs) {
                return (result, true)
            }
            
            // No overflow
            return (result, false)
        } else {
            // Overflow logic for unsigned integers
            let lhs = UInt(lhs)
            let rhs = UInt(rhs)
            
            let result = T(toUnsignedBitWidth(lhs &- rhs))
            
            // Check for negative overflow (only same signs ;) )
            if lhs < rhs {
                return (result, true)
            } else {
                return (result, false)
            }
        }
    }
    
    /// - Returns: A tuple containing the result of the multiplication along with a Boolean value indicating whether overflow occurred.
    public func multipliedReportingOverflow<T: BinaryInteger>(lhs: T, rhs: T) -> (partialValue: T, overflow: Bool) {
        
        // Check for multiplication by zero
        guard lhs != 0 && rhs != 0 else {
            return (0, false)
        }
        
        if T.isSigned {
            // Overflow logic for signed integers
            let lhs = Int(lhs)
            let rhs = Int(rhs)
            
            let result = T(toSignedBitWidth(lhs &* rhs))
            
            // Special case: lowerBound * -1 or -1 * lowerBound, overflows
            if (lhs ^ rhs) >= 0 /* Check for same signs */ && (lhs & masks.signedBit) != 0 /* Check if negative */ {
                if (lhs == -1 && rhs == ranges.signed.lowerBound) ||
                    (rhs == -1 && lhs == ranges.signed.lowerBound) {
                    return (result, true)
                }
            }
            
            if (lhs ^ rhs) >= 0 {
                // Check same signs overflow
                if ((lhs > 0 && rhs > 0 && lhs > ranges.signed.upperBound / rhs) || // Positive * Positive
                    (lhs < 0 && rhs < 0 && lhs < ranges.signed.upperBound / rhs)) { // Negative * Negative
                    return (result, true) // Overflow
                }
            } else
            // Special case 1 * -1 or -1 * 1, no overflow
            if (lhs == 1 && rhs == -1) || (lhs == -1 && rhs == 1) {
                return (result, false) // No overflow
            }
            
            // Check opposite signs overflow
            if ((lhs > 0 && rhs < 0 && rhs > ranges.signed.lowerBound / lhs) || // Positive * Negative
                (lhs < 0 && rhs > 0 && lhs < ranges.signed.lowerBound / rhs)) { // Negative * Positive
                return (result, true) // Overflow
            }
            
            // No overflow
            return (result, false)
            
        } else {
            // Overflow logic for unsigned integers
            let lhs = UInt(lhs)
            let rhs = UInt(rhs)
            
            let result = T(toUnsignedBitWidth(lhs &* rhs))
            
            if lhs > ranges.unsigned.upperBound / rhs {
                return (result, true)
            } else {
                return (result, false)
            }
        }
    }
    
    /// - Returns: A tuple containing the result of the division along with a Boolean value indicating whether overflow occurred.
    public func dividedReportingOverflow<T: BinaryInteger>(lhs: T, rhs: T) -> (partialValue: T, overflow: Bool) {
        // Division by zero check
        guard rhs != 0 else {
            return (0, true)
        }
        
        // Overflow logic for signed integers
        // Overflow occurs when dividing the minimum signed value by -1.
        // i.e. For 8 bit, -128 / -1 = +128 > than 8-bit max of 127.
        if T.isSigned && lhs == ranges.signed.lowerBound && rhs == -1 {
            return (T(ranges.signed.lowerBound), true)
        }
        
        // No overflow
        return (lhs / rhs, false)
    }
    
    /// - Returns: A tuple containing the result of the remainder operation along with a Boolean value indicating whether overflow occurred.
    public func remainderReportingOverflow<T: BinaryInteger>(lhs: T, rhs: T) -> (partialValue: T, overflow: Bool) {
        // Modulus by zero check
        guard rhs != 0 else {
            return (0, true)
        }
        
        // Overflow logic for signed integers
        // Check for overflow: minimum value modulus by -1
        // Int.min % -1 = lhs − (rhs * (lhs / rhs))
        if T.isSigned && lhs == ranges.signed.lowerBound && rhs == -1 {
            return (0, true)
        }
        
        // No overflow
        return (lhs % rhs, false)
    }
}
