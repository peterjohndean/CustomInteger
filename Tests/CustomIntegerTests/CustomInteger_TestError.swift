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
    func testInvalidBitWidthThrowsError() {
        #expect(throws: CustomInteger.CustomIntegerError.invalidBitWidth(0)) {
            _ = try CustomInteger(for: 0)
        }
        
        #expect(throws: CustomInteger.CustomIntegerError.invalidBitWidth(65)) {
            _ = try CustomInteger(for: 65)
        }
    }
    
    @Test
    func testInvalidBitWidthErrorDescription() {
        do {
            _ = try CustomInteger(for: 0)
            #expect(Bool(false), "Expected error but no error was thrown")
        } catch let error as CustomInteger.CustomIntegerError {
            #expect(error.description == "Invalid Bit Width: Must be between 1 and 64, received 0")
        } catch {
            #expect(Bool(false), "Unexpected error type: \(error)")
        }
        
        do {
            _ = try CustomInteger(for: 65)
            #expect(Bool(false), "Expected error but no error was thrown")
        } catch let error as CustomInteger.CustomIntegerError {
            #expect(error.description == "Invalid Bit Width: Must be between 1 and 64, received 65")
        } catch {
            #expect(Bool(false), "Unexpected error type: \(error)")
        }
    }
    
    @Test
    func testInvalidSignedRangeThrowsError() {
        #expect(throws: CustomInteger.CustomIntegerError.invalidSignedRange(-130, -128...127, 8)) {
            _ = try CustomInteger(for: 8).radix(value: -130) // Assume `for` represents bit width and applies range limits
        }
        
        #expect(throws: CustomInteger.CustomIntegerError.invalidSignedRange(200, -128...127, 8)) {
            _ = try CustomInteger(for: 8).radix(value: 200) // Assume `for` represents bit width and applies range limits
        }
    }
    
    @Test
    func testInvalidSignedRangeErrorDescription() {
        do {
            _ = try CustomInteger(for: 8).radix(value: -130) // Assume it tries -130
            #expect(Bool(false), "Expected error but no error was thrown")
        } catch let error as CustomInteger.CustomIntegerError {
            #expect(error.description == "Value -130 out of range for -128...127 of width 8")
        } catch {
            #expect(Bool(false), "Unexpected error type: \(error)")
        }
        
        do {
            _ = try CustomInteger(for: 8).radix(value: 200) // Assume it tries 200
            #expect(Bool(false), "Expected error but no error was thrown")
        } catch let error as CustomInteger.CustomIntegerError {
            #expect(error.description == "Value 200 out of range for -128...127 of width 8")
        } catch {
            #expect(Bool(false), "Unexpected error type: \(error)")
        }
    }
    
    @Test
    func testInvalidUnsignedRangeThrowsError() {
        #expect(throws: CustomInteger.CustomIntegerError.invalidUnsignedRange(300, 0...255, 8)) {
            _ = try CustomInteger(for: 8).radix(value: UInt(300)) // Assume it checks for unsigned range
        }
    }
    
    @Test
    func testInvalidUnsignedRangeErrorDescription() {
        do {
            _ = try CustomInteger(for: 8).radix(value: UInt(300)) // Assume it tries 300
            #expect(Bool(false), "Expected error but no error was thrown")
        } catch let error as CustomInteger.CustomIntegerError {
            #expect(error.description == "Value 300 out of range for 0...255 of width 8")
        } catch {
            #expect(Bool(false), "Unexpected error type: \(error)")
        }
    }
    
    @Test
    func testInvalidRadixThrowsError() {
        #expect(throws: CustomInteger.CustomIntegerError.invalidRadix(1)) {
            _ = try CustomInteger(for: 8).radix(value: 1, radix: 1) // Assume it checks for radix limits
        }
        
        #expect(throws: CustomInteger.CustomIntegerError.invalidRadix(37)) {
            _ = try CustomInteger(for: 8).radix(value: 1, radix: 37) // Assume it checks for radix
        }
    }
    
    @Test
    func testInvalidRadixErrorDescription() {
        do {
            _ = try CustomInteger(for: 8).radix(value: 100, radix: 1) // Assume it tries radix 1
            #expect(Bool(false), "Expected error but no error was thrown")
        } catch let error as CustomInteger.CustomIntegerError {
            #expect(error.description == "Invalid Radix: Must be between 2 and 36, received 1")
        } catch {
            #expect(Bool(false), "Unexpected error type: \(error)")
        }
        
        do {
            _ = try CustomInteger(for: 8).radix(value: 100, radix: 37) // Assume it tries radix 37
            #expect(Bool(false), "Expected error but no error was thrown")
        } catch let error as CustomInteger.CustomIntegerError {
            #expect(error.description == "Invalid Radix: Must be between 2 and 36, received 37")
        } catch {
            #expect(Bool(false), "Unexpected error type: \(error)")
        }
    }
    
    @Test
    func testValidBitWidthDoesNotThrow() {
        #expect(throws: Never.self) {
            _ = try CustomInteger(for: 8)
        }
    }
}
