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

extension CustomInteger.CustomIntegerError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
            case (.invalidBitWidth(let a), .invalidBitWidth(let b)): return a == b
            case (.invalidSignedRange(let a, let r1, let w1), .invalidSignedRange(let b, let r2, let w2)): return a == b && r1 == r2 && w1 == w2
            case (.invalidUnsignedRange(let a, let r1, let w1), .invalidUnsignedRange(let b, let r2, let w2)): return a == b && r1 == r2 && w1 == w2
            case (.invalidRadix(let a), .invalidRadix(let b)): return a == b
            default: return false
        }
    }
}

struct CustomIntegerTests {
    
    @Test
    func testInvalidBitWidth() {
        let cases: [(Int, String)] = [
            (0, "Invalid Bit Width: Must be between 1 and 64, received 0"),
            (65, "Invalid Bit Width: Must be between 1 and 64, received 65")
        ]
        
        for (bitWidth, expectedMessage) in cases {
            do {
                _ = try CustomInteger(for: bitWidth)
                #expect(Bool(false), "Expected error but no error was thrown")
            } catch let error as CustomInteger.CustomIntegerError {
                #expect(error == .invalidBitWidth(bitWidth))
                #expect(error.description == expectedMessage)
            } catch {
                #expect(Bool(false), "Unexpected error type: \(error)")
            }
        }
    }
    
    @Test
    func testInvalidSignedRange() {
        let cases: [(Int, ClosedRange<Int>, Int, String)] = [
            (-130, -128...127, 8, "Value -130 out of range for -128...127 of width 8"),
            (200, -128...127, 8, "Value 200 out of range for -128...127 of width 8")
        ]
        
        for (value, range, bitWidth, expectedMessage) in cases {
            do {
                _ = try CustomInteger(for: bitWidth).radix(value: value)
                #expect(Bool(false), "Expected error but no error was thrown")
            } catch let error as CustomInteger.CustomIntegerError {
                #expect(error == .invalidSignedRange(value, range, bitWidth))
                #expect(error.description == expectedMessage)
            } catch {
                #expect(Bool(false), "Unexpected error type: \(error)")
            }
        }
    }
    
    @Test
    func testInvalidUnsignedRange() {
        let cases: [(UInt, ClosedRange<UInt>, Int, String)] = [
            (300, 0...255, 8, "Value 300 out of range for 0...255 of width 8"),
            (UInt(1024), 0...255, 8, "Value 1024 out of range for 0...255 of width 8")
        ]
        
        for (value, range, bitWidth, expectedMessage) in cases {
            do {
                _ = try CustomInteger(for: bitWidth).radix(value: value)
                #expect(Bool(false), "Expected error but no error was thrown")
            } catch let error as CustomInteger.CustomIntegerError {
                #expect(error == .invalidUnsignedRange(value, range, bitWidth))
                #expect(error.description == expectedMessage)
            } catch {
                #expect(Bool(false), "Unexpected error type: \(error)")
            }
        }
    }
    
    @Test
    func testInvalidRadix() {
        let cases: [(Int, String)] = [
            (1, "Invalid Radix: Must be between 2 and 36, received 1"),
            (37, "Invalid Radix: Must be between 2 and 36, received 37")
        ]
        
        for (radix, expectedMessage) in cases {
            do {
                _ = try CustomInteger(for: 8).radix(value: 100, radix: radix)
                #expect(Bool(false), "Expected error but no error was thrown")
            } catch let error as CustomInteger.CustomIntegerError {
                #expect(error == .invalidRadix(radix))
                #expect(error.description == expectedMessage)
            } catch {
                #expect(Bool(false), "Unexpected error type: \(error)")
            }
        }
    }
    
    @Test
    func testValidBitWidthDoesNotThrow() {
        #expect(throws: Never.self) {
            _ = try CustomInteger(for: 8)
        }
    }
}
