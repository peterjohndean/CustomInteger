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

struct CustomInteger_Tests {
    let onBenchmarkTests = false
    
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
    
    @Test("Test Radix Conversions") func RadixConversions_Tests() {
        if let a = CustomInteger(for: 1) {
            #expect(a.radixString(value: Int16(-1), radix: 2) == "1")
            #expect(a.radixString(value: Int16(-1), radix: 16) == "1")
        }
        if let a = CustomInteger(for: 2) {
            #expect(a.radixString(value: Int16(-1), radix: 2) == "11")
            #expect(a.radixString(value: Int16(-1), radix: 16) == "3")
        }
        if let a = CustomInteger(for: 3) {
            #expect(a.radixString(value: Int16(-1), radix: 2) == "111")
            #expect(a.radixString(value: Int16(-1), radix: 16) == "7")
        }
        if let a = CustomInteger(for: 4) {
            #expect(a.radixString(value: Int16(-1), radix: 2) == "1111")
            #expect(a.radixString(value: Int16(-1), radix: 16) == "f")
        }
        if let a = CustomInteger(for: 8) {
            #expect(a.radixString(value: Int16(-42), radix: 2) == "1101_0110")
            #expect(a.radixString(value: Int16(-42), radix: 16) == "d6")
        }
    }
    
    @Test("Benchmark Tight Memory Preallocation")
    func BenchmarkTightMemoryPreallocation_Tests() {
        
        guard onBenchmarkTests else { return }
        
        func benchmarkPreallocation(bitWidth: Int, radix: Int, iterations: Int = 1_000_000) {
            var totalTime: UInt64 = 0
            let clock = ContinuousClock()  // ✅ Create an instance of ContinuousClock
            
            for _ in 0..<iterations {
                let start = clock.now  // ✅ Correct usage of ContinuousClock.now
                
                let log2Radix = log2(Double(radix))
                let minCharacters = Int(ceil(Double(bitWidth) / log2Radix))
                let separatorGroup = (radix == 2 || radix == 16) ? 4 : 3
                let separatorCount = (minCharacters - 1) / separatorGroup
                let preallocSize = minCharacters + separatorCount
                
                var result = [Character]()
                result.reserveCapacity(preallocSize)
                
                let end = clock.now  // ✅ Correct usage
                let duration = start.duration(to: end)  // ✅ Get Duration instance
                totalTime += UInt64(duration.components.attoseconds / 1_000_000_000)  // ✅ Convert attoseconds to nanoseconds
            }
            
            let avgTime = Double(totalTime) / Double(iterations)
            print("BitWidth: \(bitWidth), Radix: \(radix), Avg Time: \(avgTime) ns")
        }
        
        // Run benchmarks for different cases
        let bitWidths = [8, 16, 32, 64]   // Adjust as needed
        let radices = [2, 8, 10, 16]      // Common radices
        
        for bitWidth in bitWidths {
            for radix in radices {
                benchmarkPreallocation(bitWidth: bitWidth, radix: radix)
            }
        }
    }
    
    @Test("Benchmark Tight vs Naive Memory Preallocation")
    func BenchmarkMemoryPreallocation_Tests() {
        
        guard onBenchmarkTests else { return }
        
        func benchmarkPreallocation(bitWidth: Int, radix: Int, iterations: Int = 1_000_000) {
            var totalTimeTight: UInt64 = 0
            var totalTimeNaive: UInt64 = 0
            let clock = ContinuousClock()
            
            for _ in 0..<iterations {
                // **Tight Memory Preallocation**
                let startTight = clock.now
                
                let log2Radix = log2(Double(radix))
                let minCharacters = Int(ceil(Double(bitWidth) / log2Radix))
                let separatorGroup = (radix == 2 || radix == 16) ? 4 : 3
                let separatorCount = (minCharacters - 1) / separatorGroup
                let preallocSizeTight = minCharacters + separatorCount
                
                var resultTight = [Character]()
                resultTight.reserveCapacity(preallocSizeTight)
                
                let endTight = clock.now
                let durationTight = startTight.duration(to: endTight)
                totalTimeTight += UInt64(durationTight.components.attoseconds / 1_000_000_000)
                
                // **Naive Memory Preallocation**
                let startNaive = clock.now
                
                let groupingSize = (radix == 2 || radix == 16) ? 4 : 3
                let preallocSizeNaive = bitWidth + (bitWidth - 1) / groupingSize
                
                var resultNaive = [Character]()
                resultNaive.reserveCapacity(preallocSizeNaive)
                
                let endNaive = clock.now
                let durationNaive = startNaive.duration(to: endNaive)
                totalTimeNaive += UInt64(durationNaive.components.attoseconds / 1_000_000_000)
            }
            
            let avgTimeTight = Double(totalTimeTight) / Double(iterations)
            let avgTimeNaive = Double(totalTimeNaive) / Double(iterations)
            print("BitWidth: \(bitWidth), Radix: \(radix) | Tight: \(avgTimeTight) ns | Naive: \(avgTimeNaive) ns | Diff: \(avgTimeNaive - avgTimeTight) ns")
        }
        
        // Run benchmarks for different cases
        let bitWidths = [8, 16, 32, 64]   // Adjust as needed
        let radices = [2, 8, 10, 16]      // Common radices
        
        for bitWidth in bitWidths {
            for radix in radices {
                benchmarkPreallocation(bitWidth: bitWidth, radix: radix)
            }
        }
    }
    
    @Test("Benchmark Floating-Point vs Integer Log2 Preallocation")
    func BenchmarkLog2Preallocation_Tests() {
        
        guard onBenchmarkTests else { return }
        
        let log2Table: [Int: Int] = [
            2: 1_000_000,
            8: 3_000_000,
            10: 3_321_929,
            16: 4_000_000
        ]
        
        func floatingPointPrealloc(bitWidth: Int, radix: Int) -> Int {
            let log2Radix = log2(Double(radix))
            let minCharacters = Int(ceil(Double(bitWidth) / log2Radix))
            let separatorGroup = (radix == 2 || radix == 16) ? 4 : 3
            let separatorCount = (minCharacters - 1) / separatorGroup
            return minCharacters + separatorCount
        }
        
        func integerPrealloc(bitWidth: Int, radix: Int) -> Int {
            let scaledLog2 = log2Table[radix]!
            let minCharacters = (bitWidth * 1_000_000 + scaledLog2 - 1) / scaledLog2
            let separatorGroup = (radix == 2 || radix == 16) ? 4 : 3
            let separatorCount = (minCharacters - 1) / separatorGroup
            return minCharacters + separatorCount
        }
        
        func benchmark(_ function: (Int, Int) -> Int, bitWidth: Int, radix: Int, iterations: Int = 1_000_000) -> Double {
            var totalTime: UInt64 = 0
            for _ in 0..<iterations {
                let start = ContinuousClock.now
                _ = function(bitWidth, radix)
                let end = ContinuousClock.now
                let duration = end - start
                totalTime += UInt64(duration.components.attoseconds / 1_000_000_000) // Convert to nanoseconds
            }
            return Double(totalTime) / Double(iterations)
        }
        
        let bitWidths = [16, 24, 56, 64]
        let radices = [2, 8, 10, 16]
        
        for bitWidth in bitWidths {
            for radix in radices {
                let fpTime = benchmark(floatingPointPrealloc, bitWidth: bitWidth, radix: radix)
                let intTime = benchmark(integerPrealloc, bitWidth: bitWidth, radix: radix)
                let diff = fpTime - intTime
                print("BitWidth: \(bitWidth), Radix: \(radix) | FP: \(fpTime) ns | INT: \(intTime) ns | Diff: \(diff) ns")
            }
        }
    }
}
