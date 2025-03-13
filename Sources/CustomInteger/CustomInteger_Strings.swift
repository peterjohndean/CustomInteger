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

import Foundation

/*
 Performing hand or manual calculations for converting base10 to base8.
 
 Convert a Signed Integer to Octal (Two’s Complement)
 
 Given:
    •    Bit Width = (e.g., 12)
    •    Value = (e.g., -100)
    •    Radix = 8 (Octal)
 
 Step 1: Convert Absolute Value to Binary
 
    1. Take the absolute value of the given number: |-100| = 100
    2. Convert it to binary, ensuring it fits within the bit width: 100₁₀ → 0000 0110 0100₂ (12-bit)
 
 Step 2: Compute Two’s Complement (For Negative Numbers)
 
    Skip this step for positive numbers.
 
    1. Invert all bits (flip 0s to 1s and 1s to 0s): 0000 0110 0100₂ → 1111 1001 1011₂
    2. Add 1 to the result: 1111 1001 1011₂ + 1 = 1111 1001 1100₂
    3. Final Two’s Complement Representation: 1111 1001 1100₂
 
 Step 3: Convert to Octal (Radix 8)
 
    1. Group bits into sets of 3 (from right to left): 1111 1001 1100₂ → 111 110 011 100₈
    2. Convert each 3-bit group to octal: 111 110 011 100₈ → 7 6 3 4₈
    3. Final Octal Representation: 7634₈
    4. For signed representation, the correct answer is: -144₈ (since -100₁₀ = -144₈)
 
 */

extension CustomInteger {
    /// Converts an Integer to a formatted radix string.
    /// All values are checked for the bit-width range before conversion.
    ///
    /// - Parameters:
    ///  - value: The integer value to convert.
    ///  - radix: The base to convert the integer to (default is binary).
    /// - Returns: A formatted string representation of the integer (2's complement for base-2 & -16) in the specified radix.
    ///
    ///  # Code
    ///  ```let result = CustomInteger().radix(value: -100, radix: 8) // Output: -144₈, and not 7634₈```
    public func radix<T: BinaryInteger>(value: T, radix: Int = 2) -> String {
        
        // Check value
        guard isInRange(value) else {
            return "Value \(value) out of range for \(Self.self) of width \(self.bitWidth)"
        }
        
        // Check radix
        guard (2...36).contains(radix) else {
            return "Invalid radix \(radix) for 2...36"
        }
        
        // Mask value to the correct bit-width.
        let maskedValue = value & (T.isSigned ? T(truncatingIfNeeded: masks.signed) : T(masks.unsigned))
        
        // Calculate preallocated buffer size.
        // On an Apple M2, Tight vs Naive, tight can be up to 20ns slower, but is way more memory efficient.
        let log2Radix = log2(Double(radix))                                                 // (1) The number of bits per digit for that radix.
        let minCharacters = Int(ceil(Double(self.bitWidth) / log2Radix))                    // (2) The minimum number of characters needed.
        let separatorGroup = (radix == 2 || radix == 16) ? 4 : 3                            // (3) The number of digits per group before inserting a separator.
        let separatorCount = (minCharacters - 1) / separatorGroup                           // (4) The number of separators needed.
        let preallocSize = minCharacters + separatorCount + (isSigned(value.self) ? 1 : 0)  // (5) The final preallocation size.
        
        // Preallocate buffer
        var result = [Character]()
        result.reserveCapacity(preallocSize)
        
        // Lookup table
        let digits = Array("0123456789abcdefghijklmnopqrstuvwxyz")
        
        // Perform conversion
        switch radix {
            /*
             (1) Utilise the masked (two’s complement) value for those bases that are bit-based (binary, hexadecimal, and less frequently octal) where two’s complement is anticipated.
             (2) In the default branch (which encompasses, for instance, decimal or any other non-bit-based radix), you should employ the original value that was passed.
             (3) If the value is negative, calculate its absolute value for the digit extraction and then append a “–“ at the end.
             */
            case 2:
                // Binary is a special case, as it is bit-based.
                for i in (0..<self.bitWidth).reversed() {
                    result.append(((maskedValue >> i) & 0x1 == 1) ? "1" : "0")
                    if i % separatorGroup == 0 && i != 0 {
                        result.append("_")
                    }
                }
                
            case 16:
                // Hexadecimal is a special case, as it is bit-based.
                let nibble = T(radix - 1)
                let shiftAmount = Int(log2Radix)
                
                for i in (0..<minCharacters).reversed() {
                    result.append(digits[Int((maskedValue >> (i * shiftAmount)) & nibble)])
                    if i % separatorGroup == 0 && i != 0 {
                        result.append("_")
                    }
                }
                
            default:
                // All other radixes, such as decimal.
                let radixMagnitude = T.Magnitude(radix)
                var absValue = value.magnitude
                var digitCount = 0
                
                repeat {
                    if digitCount > 0 && digitCount % separatorGroup == 0 {
                        result.append("_")
                    }
                    
                    let digit = Int(absValue % radixMagnitude)
                    result.append(digits[digit])
                    
                    absValue /= radixMagnitude
                    digitCount += 1
                } while absValue > 0
                
                result = result.reversed()
        }
        
        return String(value < 0 ? "-" + result : result)
    }
}

