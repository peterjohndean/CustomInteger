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

public struct CustomInteger {
    // Future proofing
//    public typealias Int = Int64
//    public typealias UInt = UInt64
    
    /// Integer size in bits
    public let bitWidth: Int
    
    public struct BitWidthRanges {
        /// Signed bitWidth range from -(2^(n - 1)) to 2^(n - 1) - 1
        public let signed: ClosedRange<Int>
        
        /// Unsigned bitWidth range from 0 to 2^n - 1
        public let unsigned: ClosedRange<UInt>
    }
    
    public struct BitWidthMasks {
        /// Signed bitWidth mask (2^n) - 1
        public let signed: Int
        
        /// Signed Bit bitWidth mask 2^(n - 1)
        public let signedBit: Int
        
        /// Unsigned bitWidth mask (2^n) - 1
        public let unsigned: UInt
    }
    
    public let masks: BitWidthMasks
    public let ranges: BitWidthRanges
    
    public init?(for bits: Int) {
        
        // Support for 1...64 bitWidths
        guard bits >= 1 && bits <= Int.bitWidth else {
            return nil
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
    
    // MARK: - General methods.
    
    /// - Returns: true, if the data type is within it's own min...max range.
    @inlinable
    @inline(__always)
    public func isInRange<T: BinaryInteger>(_ value: T) -> Bool {
        return T.isSigned
        ? ranges.signed.contains(Int(value))    // Signed
        : ranges.unsigned.contains(UInt(value)) // Unsigned
    }
    
    /// - Returns: true, if the data type is signed and negative
    @inlinable
    @inline(__always)
    public func isSigned<T: BinaryInteger>(_ value: T) -> Bool {
        return T.isSigned /* Unsigned always false */ && (Int(value) & masks.signedBit) != 0
    }
    
    /// - Returns: true, if both types are the same and both signs are opposite.
    @inlinable
    @inline(__always)
    public func isSignOpposite<T: BinaryInteger>(lhs: T, rhs: T) -> Bool {
        return T.isSigned /* Unsigned integer always false */ && (lhs ^ rhs) < 0
    }
    
    /// - Returns: true, if both data types are the same and have the same signs.
    @inlinable
    @inline(__always)
    public func isSignSame<T: BinaryInteger>(lhs: T, rhs: T) -> Bool {
        return !T.isSigned /* Unsigned integer always true */ || (lhs ^ rhs) >= 0
    }
    
    /// Converts a value to a signed integer of a specific bit width, handling sign extension and truncation.
    /// - Returns: A signed, truncated bit width value.
    @inlinable
    @inline(__always)
    internal func toSignedBitWidth(_ result: Int) -> Int {
        return ((result & masks.signed) ^ masks.signedBit) &- masks.signedBit
    }
    
    /// Converts a value to an unsigned integer of a specific bit width, handling truncation.
    /// - Returns: An unsigned, truncated bit width value.
    @inlinable
    @inline(__always)
    internal func toUnsignedBitWidth(_ result: UInt) -> UInt {
        return result & masks.unsigned
    }
}
