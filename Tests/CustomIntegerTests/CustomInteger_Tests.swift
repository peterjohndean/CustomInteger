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

struct CustomInteger_Tests {
    
    @Test func General_Tests() {
        if let a = CustomInteger(for: 8) {
            #expect(a.isSigned(-1) == true)
            #expect(a.isSigned(1) == false)
            #expect(a.isSigned(UInt(1)) == false)
            
            #expect(a.isInRange(-1) == true)
            #expect(a.isInRange(UInt8(1)) == true)
            #expect(a.isInRange(-256) == false)
            
            #expect(a.isSignSame(lhs: -1, rhs: 1) == false)
            #expect(a.isSignSame(lhs: 1, rhs: 1) == true)
            #expect(a.isSignSame(lhs: 1, rhs: 1) == true)
            #expect(a.isSignSame(lhs: UInt16(1), rhs: UInt16(1)) == true)
            
            #expect(a.isSignOpposite(lhs: -1, rhs: 1) == true)
            #expect(a.isSignOpposite(lhs: 1, rhs: -1) == true)
            #expect(a.isSignOpposite(lhs: 1, rhs: 1) == false)
            #expect(a.isSignOpposite(lhs: UInt16(1), rhs: UInt16(1)) == false)
            
        }
    }
}
