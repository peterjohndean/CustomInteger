//
//  CustomInteger.swift
//  CustomInteger
//
//  Created by Peter Dean on 18/3/2025.
//


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

import Foundation

struct CustomInteger_ZeroBitCount_Tests {
    
    @Test func testTrailingZeroBitCount() throws {
        for bit in 1...64 {
            let i = try CustomInteger(for: bit)
            let smin = i.ranges.signed.lowerBound
            let smax = i.ranges.signed.upperBound
            let umin = i.ranges.unsigned.lowerBound
            let umax = i.ranges.unsigned.upperBound
            
            var testCases: [(any BinaryInteger, Int)] = [
                // Zero case
                (0, bit)
            ]
            
            // Powers of two within range
            for shift in 0..<bit {
                let powerOfTwo = 1 << shift
                if powerOfTwo <= umax {
                    testCases.append((powerOfTwo, shift))
                }
            }
            
            // Various bit patterns within range
            let bitPatterns: [UInt] = [
                0b101, 0b1000, 0b11000
            ]
            for pattern in bitPatterns {
                if bit >= 3 && pattern <= umax {
                    testCases.append((pattern, pattern.trailingZeroBitCount))
                }
            }
            
            // Signed integer special cases
            switch bit {
                    
                case 1:
                    testCases.append((smin, 0))
                    testCases.append((smax, 1))
                    
                default:
                    testCases.append((smin, bit - 1))
                    testCases.append((smax, 0))
            }
            
            // Unsigned integer special cases
            testCases.append((umin, bit)) // 0 case
            testCases.append((umax, 0))   // All bits set
            
            for (value, expected) in testCases {
                let result = i.trailingZeroBitCount(value)
                #expect(result == expected, "Failed at bitWidth: \(bit) for value: \(value), got \(result) instead of \(expected)")
            }
        }
    }
    
}
