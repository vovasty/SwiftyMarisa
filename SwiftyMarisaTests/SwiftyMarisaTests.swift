//  SwiftyMarisaTests.swift
//
//  Copyright (c) 2016, Vladimir Solomenchuk
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
//  following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice, this list of conditions and the following
//  disclaimer.
//  - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
//  disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
//  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
//  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
//  USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//  OF THE POSSIBILITY OF SUCH DAMAGE.

import XCTest
@testable import Marisa

class SwiftyMarisaTests: XCTestCase {
    func testPredictiveSearch() {
        let trie = Marisa()
        
        trie.build { (builder) -> Void in
            builder("U")
            builder("US")
            builder("USA")
        }
        
        var actual = [String]()
        var expect = ["U", "US", "USA"]
        for a in trie.search("U", .predictive) {
            actual.append(a)
        }
        
        XCTAssertEqual(expect, actual)

        actual = [String]()
        expect = ["US", "USA"]
        for a in trie.search("US", .predictive) {
            actual.append(a)
        }
        
        XCTAssertEqual(expect, actual)

    
    }
    
    func testPrefixSearch() {
        let trie = Marisa()
        
        trie.build { (builder) -> Void in
            builder("U")
            builder("US")
            builder("USA")
            builder("UK")
        }
        
        var actual = [String]()
        
        let expect = ["U", "US", "USA"]
        for a in trie.search("USA", .prefix) {
            actual.append(a)
        }
        
        XCTAssertEqual(expect, actual)
    }
    
    func testLookup() {
        let trie = Marisa()
        
        trie.build { (builder) -> Void in
            builder("apple")
        }

        XCTAssert(trie.lookup("apple"))
        XCTAssertFalse(trie.lookup("microsoft"))
        
    }

}
