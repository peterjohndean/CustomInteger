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

extension CustomInteger {
    /// Converts an Integer to a formatted radix string.
    public func radixString<T: FixedWidthInteger>(value: T, radix: Int = 2) -> String {
        
        // Check value
        guard isInRange(value) else {
            return "Value \(value) out of range for \(Self.self) of width \(self.bitWidth)"
        }
        
        // Check radix
        guard (2...36).contains(radix) else {
            return "Invalid radix \(radix) for 2...36"
        }
        
        // Apply bit width mask
        let value = value & T(masks.signed)
        
        /*
         Compute preallocation size
         --------------------------
         Memory Preallocation Formulae and Explanation
         General Formula for Any Radix (r):
            For any radix r, the total character count formula is: ceil(bitWidth / log2(r)) + floor((ceil(bitWidth / log2(r)) - 1) / g)
            Where:
                - bitWidth is the number of bits in the value.
                - r is the radix (base) of the numerical system.
                - log2(r) converts radix to bit-width equivalence.
                - g is the separator grouping, which is:
                - 4 for radix 2 and 16 (grouping every 4 characters).
                - 3 for radix 8 and 10 (grouping every 3 characters).
         
         Naive Preallocation Approach:
            A simpler but less memory-efficient approach is: bitWidth + floor(bitWidth - 1 / g)
            Where:
                - The main value requires bitWidth characters.
                - Separators (_) are added every g characters.
         
         Example Comparisons:
         For a 32-bit value:
            1. Radix 2 (binary):
                - Tight formula: ceil(32 / log2(2)) + floor((32 - 1) / 4) = 32 + 7 = 39
                - Naive approach: 32 + floor((32 - 1) / 4) = 32 + 7 = 39
            2. Radix 16 (hex):
                - Tight formula: ceil(32 / log2(16)) + floor((8 - 1) / 4) = 8 + 1 = 9
                - Naive approach: 32 + floor(32 - 1 / 4) = 32 + 7 = 39
         
         Conclusion:
         On an Apple M2, Tight vs Naive, tight can be up to 20ns slower, but is way more memory efficient.
         */
        
        /*
         --------------------------------------------------------------------------------
         Detailed Explanation of Code
         --------------------------------------------------------------------------------
         
         1. Compute log2(radix)
         --------------------------------------------------------------------------------
         let log2Radix = log2(Double(radix))
         --------------------------------------------------------------------------------
         - Converts `radix` to `Double` to allow floating-point math.
         - Applies `log2()` to get the **number of bits per digit** in that radix.
         - This tells us **how many bits each digit can represent**.
         
         **Example Calculations:**
         - log2(2)   = 1.0    → 1 bit per digit
         - log2(8)   ≈ 3.0    → 3 bits per digit
         - log2(10)  ≈ 3.32   → ~3.32 bits per digit
         - log2(16)  = 4.0    → 4 bits per digit
         
         --------------------------------------------------------------------------------
         
         2. Compute Minimum Characters Needed
         --------------------------------------------------------------------------------
         let minCharacters = Int(ceil(Double(self.bitWidth) / log2Radix))
         --------------------------------------------------------------------------------
         - Converts `bitWidth` to `Double` to ensure floating-point division.
         - Divides `bitWidth` by `log2Radix` to estimate the **number of digits needed**.
         - Uses `ceil(...)` to **round up**, ensuring we allocate enough space.
         - Converts back to `Int` since the number of digits must be whole.
         
         **Example (bitWidth = 32):**
         - Radix 2   → ceil(32 / 1.0)   = **32** digits
         - Radix 8   → ceil(32 / 3.0)   = **11** digits
         - Radix 10  → ceil(32 / 3.32)  = **10** digits
         - Radix 16  → ceil(32 / 4.0)   = **8** digits
         
         --------------------------------------------------------------------------------
         
         3. Determine Separator Group Size
         --------------------------------------------------------------------------------
         let separatorGroup = (radix == 2 || radix == 16) ? 4 : 3
         --------------------------------------------------------------------------------
         - Defines the **number of digits per group** before inserting a separator `_`.
         - Follows **common formatting rules**:
         - **Binary (radix 2) & Hex (radix 16)** → Groups of **4** digits.
         - **Octal (radix 8) & Decimal (radix 10)** → Groups of **3** digits.
         
         **Example:**
         - Radix 2   → `1111_0000_1010_...`
         - Radix 8   → `745_233_...`
         - Radix 10  → `123_456_789`
         - Radix 16  → `F3A2_78B5_...`
         
         --------------------------------------------------------------------------------
         
         4. Compute the Number of Separators
         --------------------------------------------------------------------------------
         let separatorCount = (minCharacters - 1) / separatorGroup
         --------------------------------------------------------------------------------
         - Computes how many **separator `_` characters** will be inserted.
         - `(minCharacters - 1)` ensures the first digit is **not preceded by `_`**.
         - Integer division `/ separatorGroup` gives the **number of full groups**.
         
         **Example (minCharacters = 32, separatorGroup = 4):**
         - Radix 2   → (32 - 1) / 4  = **7** separators
         - Radix 8   → (11 - 1) / 3  = **3** separators
         - Radix 10  → (10 - 1) / 3  = **3** separators
         - Radix 16  → (8 - 1) / 4   = **1** separator
         
         --------------------------------------------------------------------------------
         
         5. Compute the Final Preallocation Size
         --------------------------------------------------------------------------------
         let preallocSize = minCharacters + separatorCount
         --------------------------------------------------------------------------------
         - Adds the **minimum number of digits** to the **separator count**.
         - This gives the **total number of characters** to reserve in memory.
         
         **Example (bitWidth = 32):**
         - Radix 2   →  32 + 7  = **39 characters**
         - Radix 8   →  11 + 3  = **14 characters**
         - Radix 10  →  10 + 3  = **13 characters**
         - Radix 16  →  8 + 1   = **9 characters**
         
         --------------------------------------------------------------------------------
         
         ### **Final Summary**
         This formula ensures we **preallocate just enough space** before appending characters:
         1. Compute how many digits are needed (`minCharacters`).
         2. Determine the grouping style (`separatorGroup`).
         3. Calculate the number of `_` separators (`separatorCount`).
         4. Sum them to get the **preallocated array size** (`preallocSize`).
         
         ** Why is this useful?**
         - **Avoids reallocation overhead** while appending characters.
         - **Minimizes memory usage** while still ensuring all characters fit.
         - **Optimized for different radices** (binary, octal, decimal, hex).
         */
        
        // Calculate preallocated buffer size
        let log2Radix = log2(Double(radix))
        let minCharacters = Int(ceil(Double(self.bitWidth) / log2Radix))
        let separatorGroup = (radix == 2 || radix == 16) ? 4 : 3
        let separatorCount = (minCharacters - 1) / separatorGroup
        let preallocSize = minCharacters + separatorCount
        
        // Preallocate buffer
        var result = [Character]()
        result.reserveCapacity(preallocSize)
        
        // Perform conversion
        switch radix {
            case 2:
                for i in (0..<self.bitWidth).reversed() {
                    result.append(((value >> i) & 0x1 == 1) ? "1" : "0")
                    if i % 4 == 0 && i != 0 {
                        result.append("_")
                    }
                }
                
            case 8, 10, 16:
                let digits = Array("0123456789abcdefghijklmnopqrstuvwxyz")
                let shiftAmount = Int(log2Radix)
                
                for i in (0..<minCharacters).reversed() {
                    result.append(digits[Int((value >> (i * shiftAmount)) & T(radix - 1))])
                    if i % separatorGroup == 0 && i != 0 {
                        result.append("_")
                    }
                }
            
//            case 16:
//                let hexDigits: [Character] = Array("0123456789ABCDEF")
//                
//                for i in (0..<max(1, (self.bitWidth + 3) / 4)).reversed() {
//                    let nibble = (value >> (i * 4)) & 0xF  // Shift and mask
//                    result.append(hexDigits[Int(nibble)])
//                    if i % 4 == 0 && i != 0 {
//                        result.append("_")
//                    }
//                }
                
            default:
                return "Not Supported"
        }
        
        return String(result)
    }
}

