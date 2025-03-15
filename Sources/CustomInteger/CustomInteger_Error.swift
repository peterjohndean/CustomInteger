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

extension CustomInteger: Error {
    
    /// CustomInteger Errors
    public enum CustomIntegerError: Error, CustomStringConvertible {
        case invalidBitWidth(Int)
        case invalidSignedRange(Int, ClosedRange<Int>, Int)
        case invalidUnsignedRange(UInt, ClosedRange<UInt>, Int)
        case invalidRadix(Int)
        
        public var description: String {
            switch self {
                case .invalidBitWidth(let value):
                    return "Invalid Bit Width: Must be between 1 and 64, received \(value)"
                    
                case .invalidRadix(let value):
                    return "Invalid Radix: Must be between 2 and 36, received \(value)"
                    
                case .invalidSignedRange(let value, let range, let bitWidth):
                    return "Value \(value) out of range for \(range) of width \(bitWidth)"
                    
                case .invalidUnsignedRange(let value, let range, let bitWidth):
                    return "Value \(value) out of range for \(range) of width \(bitWidth)"
            }
        }
    }
}
