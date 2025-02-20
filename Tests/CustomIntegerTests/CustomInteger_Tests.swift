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
    
    // Copilot generated tests
    @Test("Test Radix Conversions for Bit Widths 1 to 64")
    func testRadixStringConversionsAgainstItself() {
        let radices = [2, 8, 10, 16, 20]
        
        for bit in 1...64 {
            if let customInt = CustomInteger(for: bit) {
                for radix in radices {
                    let value = Int(bit) - 1
                    let expectedValue = customInt.radixString(value: value, radix: radix)
                    let result = customInt.radixString(value: value, radix: radix)
                    
                    #expect(result == expectedValue, "Failed for bit width \(bit) and radix \(radix). Expected \(expectedValue) but got \(result).")
                }
            }
        }
    }
    
    @Test("Test Radix Conversions for Bit Widths 1 to 64")
    func testRadixStringConversions() {
        let radices = [2, 8, 10, 16, 20]
        let expectedResults: [Int: [Int: (Int, String)]] = [
            1: [2: (0, "0"), 8: (0, "0"), 10: (0, "0"), 16: (0, "0"), 20: (0, "0")],
            2: [2: (1, "01"), 8: (1, "1"), 10: (1, "1"), 16: (1, "1"), 20: (1, "1")],
            3: [2: (3, "011"), 8: (3, "3"), 10: (3, "3"), 16: (3, "3"), 20: (3, "3")],
            4: [2: (7, "0111"), 8: (7, "7"), 10: (7, "7"), 16: (7, "7"), 20: (7, "7")],
            8: [2: (127, "0111_1111"), 8: (127, "177"), 10: (127, "127"), 16: (127, "7f"), 20: (127, "67")],
            16: [2: (32767, "0111_1111_1111_1111"), 8: (32767, "77_777"), 10: (32767, "32_767"), 16: (32767, "7fff"), 20: (32767, "4_1i7")],
            32: [2: (2147483647, "0111_1111_1111_1111_1111_1111_1111_1111"), 8: (2147483647, "17_777_777_777"), 10: (2147483647, "2_147_483_647"), 16: (2147483647, "7fff_ffff"), 20: (2147483647, "1d_b1f_927")],
            64: [2: (9223372036854775807, "0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (9223372036854775807, "777_777_777_777_777_777_777"), 10: (9223372036854775807, "9_223_372_036_854_775_807"), 16: (9223372036854775807, "7fff_ffff_ffff_ffff"), 20: (9223372036854775807, "5cb_fji_a3f_h26_ja7")]
        ]
        
        for bit in 1...64 {
            if let customInt = CustomInteger(for: bit) {
                for radix in radices {
                    if let (value, expectedValue) = expectedResults[bit]?[radix] {
                        let result = customInt.radixString(value: value, radix: radix)
                        #expect(result == expectedValue, "Failed for bit width \(bit) and radix \(radix). Expected \(expectedValue) but got \(result).")
                    }
                }
            }
        }
    }
    
    @Test("Test Radix Conversions") func RadixConversions_Tests() {
//        for bit in 1...64 {
//            if let a = CustomInteger(for: bit) {
//                
//                print("Testing bit \(a.bitWidth)")
//                let r2 = a.radixString(value: -1, radix: 2)
//                let r8 = a.radixString(value: Int16(-1), radix: 8)
//                let r10 = a.radixString(value: Int16(-1), radix: 10)
//                let r16 = a.radixString(value: Int16(-1), radix: 16)
//                let r20 = a.radixString(value: Int16(-1), radix: 20)
//                
//                print("r2", r2)
//                print("r8", r8)
//                print("r10", r10)
//                print("r16", r16)
//                print("r20", r20)
//                
//                #expect(r2 == "-1")
//                #expect(r8 == "-1")
//                #expect(r10 == "-1")
//                #expect(r16 == "-1")
//                #expect(r20 == "-1")
//            }
//        }
        
        if let a = CustomInteger(for: 1) {
            #expect(a.radixString(value: Int16(-1), radix: 2) == "-1")
            #expect(a.radixString(value: Int16(-1), radix: 16) == "-1")
        }
        if let a = CustomInteger(for: 2) {
            #expect(a.radixString(value: Int16(-1), radix: 2) == "-11")
            #expect(a.radixString(value: Int16(-1), radix: 16) == "-3")
        }
        if let a = CustomInteger(for: 3) {
            #expect(a.radixString(value: Int16(-1), radix: 2) == "-111")
            #expect(a.radixString(value: Int16(-1), radix: 16) == "-7")
        }
        if let a = CustomInteger(for: 4) {
            #expect(a.radixString(value: Int16(-1), radix: 2) == "-1111")
            #expect(a.radixString(value: Int16(-1), radix: 16) == "-f")
        }
        if let a = CustomInteger(for: 8) {
            #expect(a.radixString(value: Int16(-42), radix: 2) == "-1101_0110")
            #expect(a.radixString(value: Int16(-42), radix: 16) == "-d6")
        }
        if let a = CustomInteger(for: 64) {
            #expect(a.radixString(value: Int64(-2_000_000), radix: 20) == "-ca_000")
        }
    }
    
    @Test("Benchmark Tests")
    func BenchMark_Tests() {
        
        guard onBenchmarkTests else { return }
        
        //            @Test("Benchmark Tight Memory Preallocation")
        func BenchmarkTightMemoryPreallocation_Tests(_ label: String = "") {

            print(label)
            
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
        
//        @Test("Benchmark Tight vs Naive Memory Preallocation")
        func BenchmarkMemoryPreallocation_Tests(_ label: String = "") {
            
            print(label)
            
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
        
//        @Test("Benchmark Floating-Point vs Integer Log2 Preallocation")
        func BenchmarkLog2Preallocation_Tests(_ label: String = "") {
            
            print(label)
            
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
        
        BenchmarkTightMemoryPreallocation_Tests("Benchmark Tight Memory Preallocation")
        BenchmarkMemoryPreallocation_Tests("Benchmark Tight vs Naive Memory Preallocation")
        BenchmarkLog2Preallocation_Tests("Benchmark Floating-Point vs Integer Log2 Preallocation")
        
    }
    
}
