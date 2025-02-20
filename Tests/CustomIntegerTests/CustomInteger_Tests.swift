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
    
    @Test("Test Radix Conversions for Bit Widths 1 to 64")
    func testRadixStringConversions() {
        let radices = [2, 8, 10, 16, 20]
        let expectedResults: [Int: [Int: (Int, String)]] = [
            1:  [2: (0, "0"), 8: (0, "0"), 10: (0, "0"), 16: (0, "0"), 20: (0, "0")],
            2:  [2: (1, "01"), 8: (1, "1"), 10: (1, "1"), 16: (1, "1"), 20: (1, "1")],
            3:  [2: (3, "011"), 8: (3, "3"), 10: (3, "3"), 16: (3, "3"), 20: (3, "3")],
            4:  [2: (7, "0111"), 8: (7, "7"), 10: (7, "7"), 16: (7, "7"), 20: (7, "7")],
            5:  [2: (15, "0_1111"), 8: (15, "17"), 10: (15, "15"), 16: (15, "0f"), 20: (15, "f")],
            6:  [2: (31, "01_1111"), 8: (31, "37"), 10: (31, "31"), 16: (31, "1f"), 20: (31, "1b")],
            7:  [2: (63, "011_1111"), 8: (63, "77"), 10: (63, "63"), 16: (63, "3f"), 20: (63, "33")],
            8:  [2: (127, "0111_1111"), 8: (127, "177"), 10: (127, "127"), 16: (127, "7f"), 20: (127, "67")],
            9:  [2: (255, "0_1111_1111"), 8: (255, "377"), 10: (255, "255"), 16: (255, "0ff"), 20: (255, "cf")],
            10: [2: (511, "01_1111_1111"), 8: (511, "777"), 10: (511, "511"), 16: (511, "1ff"), 20: (511, "15b")],
            11: [2: (1023, "011_1111_1111"), 8: (1023, "1_777"), 10: (1023, "1_023"), 16: (1023, "3ff"), 20: (1023, "2b3")],
            12: [2: (2047, "0111_1111_1111"), 8: (2047, "3_777"), 10: (2047, "2_047"), 16: (2047, "7ff"), 20: (2047, "527")],
            13: [2: (4095, "0_1111_1111_1111"), 8: (4095, "7_777"), 10: (4095, "4_095"), 16: (4095, "0fff"), 20: (4095, "a4f")],
            14: [2: (8191, "01_1111_1111_1111"), 8: (8191, "17_777"), 10: (8191, "8_191"), 16: (8191, "1fff"), 20: (8191, "1_09b")],
            15: [2: (16383, "011_1111_1111_1111"), 8: (16383, "37_777"), 10: (16383, "16_383"), 16: (16383, "3fff"), 20: (16383, "2_0j3")],
            16: [2: (32767, "0111_1111_1111_1111"), 8: (32767, "77_777"), 10: (32767, "32_767"), 16: (32767, "7fff"), 20: (32767, "4_1i7")],
            17: [2: (65535, "0_1111_1111_1111_1111"), 8: (65535, "177_777"), 10: (65535, "65_535"), 16: (65535, "0_ffff"), 20: (65535, "8_3gf")],
            18: [2: (131071, "01_1111_1111_1111_1111"), 8: (131071, "377_777"), 10: (131071, "131_071"), 16: (131071, "1_ffff"), 20: (131071, "g_7db")],
            19: [2: (262143, "011_1111_1111_1111_1111"), 8: (262143, "777_777"), 10: (262143, "262_143"), 16: (262143, "3_ffff"), 20: (262143, "1c_f73")],
            20: [2: (524287, "0111_1111_1111_1111_1111"), 8: (524287, "1_777_777"), 10: (524287, "524_287"), 16: (524287, "7_ffff"), 20: (524287, "35_ae7")],
            21: [2: (1048575, "0_1111_1111_1111_1111_1111"), 8: (1048575, "3_777_777"), 10: (1048575, "1_048_575"), 16: (1048575, "0f_ffff"), 20: (1048575, "6b_18f")],
            22: [2: (2097151, "01_1111_1111_1111_1111_1111"), 8: (2097151, "7_777_777"), 10: (2097151, "2_097_151"), 16: (2097151, "1f_ffff"), 20: (2097151, "d2_2hb")],
            23: [2: (4194303, "011_1111_1111_1111_1111_1111"), 8: (4194303, "17_777_777"), 10: (4194303, "4_194_303"), 16: (4194303, "3f_ffff"), 20: (4194303, "164_5f3")],
            24: [2: (8388607, "0111_1111_1111_1111_1111_1111"), 8: (8388607, "37_777_777"), 10: (8388607, "8_388_607"), 16: (8388607, "7f_ffff"), 20: (8388607, "2c8_ba7")],
            25: [2: (16777215, "0_1111_1111_1111_1111_1111_1111"), 8: (16777215, "77_777_777"), 10: (16777215, "16_777_215"), 16: (16777215, "0ff_ffff"), 20: (16777215, "54h_30f")],
            26: [2: (33554431, "01_1111_1111_1111_1111_1111_1111"), 8: (33554431, "177_777_777"), 10: (33554431, "33_554_431"), 16: (33554431, "1ff_ffff"), 20: (33554431, "a9e_61b")],
            27: [2: (67108863, "011_1111_1111_1111_1111_1111_1111"), 8: (67108863, "377_777_777"), 10: (67108863, "67_108_863"), 16: (67108863, "3ff_ffff"), 20: (67108863, "1_0j8_c33")],
            28: [2: (134217727, "0111_1111_1111_1111_1111_1111_1111"), 8: (134217727, "777_777_777"), 10: (134217727, "134_217_727"), 16: (134217727, "7ff_ffff"), 20: (134217727, "2_1ih_467")],
            29: [2: (268435455, "0_1111_1111_1111_1111_1111_1111_1111"), 8: (268435455, "1_777_777_777"), 10: (268435455, "268_435_455"), 16: (268435455, "0fff_ffff"), 20: (268435455, "4_3he_8cf")],
            30: [2: (536870911, "01_1111_1111_1111_1111_1111_1111_1111"), 8: (536870911, "3_777_777_777"), 10: (536870911, "536_870_911"), 16: (536870911, "1fff_ffff"), 20: (536870911, "8_7f8_h5b")],
            32: [2: (2147483647, "0111_1111_1111_1111_1111_1111_1111_1111"), 8: (2147483647, "17_777_777_777"), 10: (2147483647, "2_147_483_647"), 16: (2147483647, "7fff_ffff"), 20: (2147483647, "1d_b1f_927")],
            33: [2: (4294967295, "0_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (4294967295, "37_777_777_777"), 10: (4294967295, "4_294_967_295"), 16: (4294967295, "0_ffff_ffff"), 20: (4294967295, "37_23a_i4f")],
            34: [2: (8589934591, "01_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (8589934591, "77_777_777_777"), 10: (8589934591, "8_589_934_591"), 16: (8589934591, "1_ffff_ffff"), 20: (8589934591, "6e_471_g9b")],
            35: [2: (17179869183, "011_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (17179869183, "177_777_777_777"), 10: (17179869183, "17_179_869_183"), 16: (17179869183, "3_ffff_ffff"), 20: (17179869183, "d8_8e3_cj3")],
            36: [2: (34359738367, "0111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (34359738367, "377_777_777_777"), 10: (34359738367, "34_359_738_367"), 16: (34359738367, "7_ffff_ffff"), 20: (34359738367, "16g_h87_5i7")],
            37: [2: (68719476735, "0_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (68719476735, "777_777_777_777"), 10: (68719476735, "68_719_476_735"), 16: (68719476735, "0f_ffff_ffff"), 20: (68719476735, "2dd_ege_bgf")],
            38: [2: (137438953471, "01_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (137438953471, "1_777_777_777_777"), 10: (137438953471, "137_438_953_471"), 16: (137438953471, "1f_ffff_ffff"), 20: (137438953471, "577_9d9_3db")],
            39: [2: (274877906943, "011_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (274877906943, "3_777_777_777_777"), 10: (274877906943, "274_877_906_943"), 16: (274877906943, "3f_ffff_ffff"), 20: (274877906943, "aee_j6i_773")],
            40: [2: (549755813887, "0111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (549755813887, "7_777_777_777_777"), 10: (549755813887, "549_755_813_887"), 16: (549755813887, "7f_ffff_ffff"), 20: (549755813887, "1_199_idg_ee7")],
            41: [2: (1099511627775, "0_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (1099511627775, "17_777_777_777_777"), 10: (1099511627775, "1_099_511_627_775"), 16: (1099511627775, "0ff_ffff_ffff"), 20: (1099511627775, "2_2ij_h7d_98f")],
            42: [2: (2199023255551, "01_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (2199023255551, "37_777_777_777_777"), 10: (2199023255551, "2_199_023_255_551"), 16: (2199023255551, "1ff_ffff_ffff"), 20: (2199023255551, "4_5hj_ef6_ihb")],
            43: [2: (4398046511103, "011_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (4398046511103, "77_777_777_777_777"), 10: (4398046511103, "4_398_046_511_103"), 16: (4398046511103, "3ff_ffff_ffff"), 20: (4398046511103, "8_bfj_9ad_hf3")],
            44: [2: (8796093022207, "0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (8796093022207, "177_777_777_777_777"), 10: (8796093022207, "8_796_093_022_207"), 16: (8796093022207, "7ff_ffff_ffff"), 20: (8796093022207, "h_3bi_j17_fa7")],
            45: [2: (17592186044415, "0_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (17592186044415, "377_777_777_777_777"), 10: (17592186044415, "17_592_186_044_415"), 16: (17592186044415, "0fff_ffff_ffff"), 20: (17592186044415, "1e_73h_i2f_b0f")],
            
            46: [2: (35184372088831, "01_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (35184372088831, "777_777_777_777_777"), 10: (35184372088831, "35_184_372_088_831"), 16: (35184372088831, "1fff_ffff_ffff"), 20: (35184372088831, "38_e7f_g5b_21b")],
            47: [2: (70368744177663, "011_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (70368744177663, "1_777_777_777_777_777"), 10: (70368744177663, "70_368_744_177_663"), 16: (70368744177663, "3fff_ffff_ffff"), 20: (70368744177663, "6h_8fb_cb2_433")],
            48: [2: (140737488355327, "0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (140737488355327, "3_777_777_777_777_777"), 10: (140737488355327, "140_737_488_355_327"), 16: (140737488355327, "7fff_ffff_ffff"), 20: (140737488355327, "de_hb3_524_867")],
            49: [2: (281474976710655, "0_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (281474976710655, "7_777_777_777_777_777"), 10: (281474976710655, "281_474_976_710_655"), 16: (281474976710655, "0_ffff_ffff_ffff"), 20: (281474976710655, "179_f26_a48_gcf")],
            50: [2: (562949953421311, "01_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (562949953421311, "17_777_777_777_777_777"), 10: (562949953421311, "562_949_953_421_311"), 16: (562949953421311, "1_ffff_ffff_ffff"), 20: (562949953421311, "2ej_a4d_08h_d5b")],
            
            64: [2: (9223372036854775807, "0111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111"), 8: (9223372036854775807, "777_777_777_777_777_777_777"), 10: (9223372036854775807, "9_223_372_036_854_775_807"), 16: (9223372036854775807, "7fff_ffff_ffff_ffff"), 20: (9223372036854775807, "5cb_fji_a3f_h26_ja7")]
        ]
        
        for bit in 1...64 {
            if let customInt = CustomInteger(for: bit) {
                for radix in radices {
                    if let (value, expectedValue) = expectedResults[bit]?[radix] {
                        let result = customInt.radixString(value: customInt.ranges.signed.upperBound, radix: radix)
                        #expect(result == expectedValue, "Value \(value) Failed for bit width \(bit) and radix \(radix). Expected \(expectedValue) but got \(result).")
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
