//  SwiftyMarisaTests.swift
//
//  Copyright (c) 2016, Vladimir Solomenchuk
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted
//  provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice, this list of conditions
//  and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright notice, this list of
//    conditions and the following
//  disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
//  OR IMPLIED WARRANTIES,
//  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
//  PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL,
//  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
//  GOODS OR SERVICES; LOSS OF
//  USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import SwiftyMarisa
import Testing

struct SwiftyMarisaTests {
    @Test
    func predictiveSearch() {
        let trie = Marisa()

        trie.build { builder in
            builder("U")
            builder("US")
            builder("USA")
        }

        var expect = ["U", "US", "USA"]
        var actual = trie.search("U", .predictive).map { $0 }

        #expect(expect == actual)

        expect = ["US", "USA"]
        actual = trie.search("US", .predictive).map { $0 }

        #expect(expect == actual)
    }

    @Test
    func testPredictiveSearchEmpty() {
        let trie = Marisa()

        trie.build { builder in
            builder("USA")
        }

        let expect = [String]()
        let actual = trie.search("UK", .prefix).map { $0 }

        #expect(expect == actual)
    }

    func testPrefixSearch() {
        let trie = Marisa()

        trie.build { builder in
            builder("U")
            builder("US")
            builder("USA")
            builder("UK")
        }

        let expect = ["U", "US", "USA"]
        let actual = trie.search("USA", .prefix).map { $0 }

        #expect(expect == actual)
    }

    func testPrefixSearchEmpty() {
        let trie = Marisa()

        trie.build { builder in
            builder("UK")
        }

        let expect = [String]()
        let actual = trie.search("USA", .prefix).map { $0 }

        #expect(expect == actual)
    }

    func testLookup() {
        let trie = Marisa()

        trie.build { builder in
            builder("apple")
        }

        #expect(trie.lookup("apple"))
        #expect(!trie.lookup("microsoft"))
    }
}
