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

public struct CustomInteger: Sendable {
    
    /// Integer size in bits
    public let bitWidth: Int
    
    public struct BitWidthRanges: Sendable {
        /// Signed bitWidth range from -(2⁽ⁿ⁻¹⁾) to 2⁽ⁿ⁻¹⁾ - 1
        public let signed: ClosedRange<Int>
        
        /// Unsigned bitWidth range from 0 to 2ⁿ - 1
        public let unsigned: ClosedRange<UInt>
    }
    
    public struct BitWidthMasks: Sendable {
        /// Signed bitWidth mask 2ⁿ - 1
        public let signed: Int
        
        /// Signed Bit bitWidth mask 2⁽ⁿ⁻¹⁾
        public let signedBit: Int
        
        /// Unsigned bitWidth mask 2ⁿ - 1
        public let unsigned: UInt
    }
    
    public let masks: BitWidthMasks
    public let ranges: BitWidthRanges
    
    public init(for bits: Int) throws {
        
        // Support for 1...64 bitWidths
        guard bits >= 1 && bits <= Int.bitWidth else {
            throw CustomIntegerError.invalidBitWidth(bits)
        }
        
        bitWidth = bits
        
        // Store signed & unsigned ranges
        ranges = BitWidthRanges(
            signed: (0 &- (1 << (bitWidth &- 1)))...((1 << (bitWidth &- 1)) &- 1),
            unsigned: 0...(1 << bitWidth) &- 1
        )
        
        // Store bitWidth masks
        masks = BitWidthMasks(
            signed: (1 << bits) &- 1,
            signedBit: 1 << (bits &- 1),
            unsigned: (1 << bits) &- 1
        )
    }
}
