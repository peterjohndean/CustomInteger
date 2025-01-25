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
    public func addingReportOverflow<T: BinaryInteger>(lhs: T, rhs: T) -> (partialValue: T, overflow: Bool) {
        if T.isSigned {
            // Overflow logic for signed integers
            let lhs = Int(lhs)
            let rhs = Int(rhs)
            
            // Check for opposite signs, no risk of overflow
            guard (lhs ^ rhs) >= 0 else {
                return (T(lhs &+ rhs), false)
            }
            
            // Check for positive overflow (same signs)
            if lhs > 0 && lhs > ranges.signed.upperBound &- rhs {
                return (T(lhs &+ rhs), true)
            } else
            // Check for negative overflow (same signs)
            if lhs < 0 && lhs < ranges.signed.lowerBound &- rhs {
                return (T(lhs &+ rhs), true)
            }
            
            // No overflow
            return (T(lhs &+ rhs), false)
            
        } else {
            // Overflow logic for unsigned integers
            let lhs = UInt(lhs)
            let rhs = UInt(rhs)
            
            // Check for positive overflow (only same signs ;) )
            if rhs > (ranges.unsigned.upperBound &- UInt(lhs)) {
                return (0, true)
            } else {
                return (T(lhs &+ rhs), false)
            }
        }
    }
    
    /// - Returns: true, if lhs `-` rhs will result in an arithmetic overflow.
    public func subtractionReportOverflow<T: BinaryInteger>(lhs: T, rhs: T) -> Bool {
        if T.isSigned {
            // Overflow logic for signed integers
            guard (lhs ^ rhs) < 0 else {
                return false // Same signs, no risk of overflow
            }
            
            let rhs = Int(rhs)
            
            // Check for positive overflow
            if lhs > 0 && lhs > ranges.signed.upperBound &+ rhs {
                return true
            } else
            // Check for negative overflow
            if lhs < 0 && lhs < ranges.signed.lowerBound &+ rhs {
                return true
            }
            
            // No overflow
            return false
        } else {
            // Overflow logic for unsigned integers
            return lhs < rhs // lhs < rhs -> Negative result -> Overflow
        }
    }
    
    /// - Returns: true, if lhs `*` rhs will result in an arithmetic overflow.
    public func multiplicationReportOverflow<T: BinaryInteger>(lhs: T, rhs: T) -> Bool {
        guard lhs != 0 && rhs != 0 else {
            return false // Multiplication by zero
        }
        
        if T.isSigned {
            // Overflow logic for signed integers
            let lhs = Int(lhs)
            let rhs = Int(rhs)
            
            if (lhs ^ rhs) >= 0 {
                // Same signs
                if ((lhs > 0 && rhs > 0 && lhs > ranges.signed.upperBound / rhs) || // Positive * Positive
                    (lhs < 0 && rhs < 0 && lhs < ranges.signed.upperBound / rhs)) { // Negative * Negative
                    return true; // Overflow
                }
            } else {
                // Opposite signs
                if ((lhs > 0 && rhs < 0 && lhs > ranges.signed.lowerBound / rhs) || // Positive * Negative
                    (lhs < 0 && rhs > 0 && lhs < ranges.signed.lowerBound / rhs)) { // Negative * Positive
                    return true; // Overflow
                }
            }
            
            // No overflow
            return false
            
        } else {
            // Overflow logic for unsigned integers
            return lhs > ranges.unsigned.upperBound / UInt(rhs)
        }
    }
    
    /// - Returns: true, if lhs `/` rhs will result in an arithmetic overflow.
    public func divisionReportOverflow<T: BinaryInteger>(lhs: T, rhs: T) -> Bool {
        // Division by zero check
        guard rhs != 0 else {
            return true
        }
        
        // Overflow logic for signed integers
        // Overflow occurs when dividing the minimum signed value by -1.
        // i.e. For 8 bit, -128 / -1 = +128 > than 8-bit max of 127.
        if T.isSigned && lhs == ranges.signed.lowerBound && rhs == -1 {
            return true
            
        }
        
        // No overflow
        return false
        
    }
    
    /// - Returns: true, if lhs `%` rhs will result in an arithmetic overflow.
    public func remainderReportOverflow<T: BinaryInteger>(lhs: T, rhs: T) -> Bool {
        // Modulus by zero check
        guard rhs != 0 else {
            return true
        }
        
        // Overflow logic for signed integers
        // Check for overflow: minimum value modulus by -1
        // Int.min % -1 = lhs − (rhs * (lhs / rhs))
        if T.isSigned && lhs == ranges.signed.lowerBound && rhs == -1 {
            return true
        }
        
        // No overflow
        return false
    }
}
