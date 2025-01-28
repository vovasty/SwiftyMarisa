//  Marisa.swift
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

import marisa_trie
import Foundation

public extension MarisaSearchType {
    // Searches keys from the possible prefixes of a query string.
    static var prefix: MarisaSearchType { MarisaSearchType(0) }
    // Searches keys starting with a query string
    static var predictive: MarisaSearchType { MarisaSearchType(1) }
}

public final class Marisa {
    private let context = marisa_create_context()!

    public init() {}

    /**
     Adds data to the trie.
     - parameter builder: Closure with a `builder` parameter. `builder` accepts a string parameter.

     ```
     ...
     trie.build { (builder) -> Void in
        builder("U")
        builder("US")
        builder("USA")
     }
     ...
     ```
     */
    public func build(_ builder: ((String) -> Void) -> Void) {
        let b: (String) -> Void = { marisa_add_word(self.context, $0) }
        builder(b)
        marisa_build_tree(context)
    }

    /**
     Searches keys from the possible prefixes of a query string.
     - parameter query: Search string.
     - parameter type: Search type.
     - returns: a sequence.
     */
    public func search(_ query: String, _ type: MarisaSearchType) -> AnySequence<String> {
        return AnySequence(SearchResults(context: context, query: query, type: type))
    }

    /**
     Checks whether or not a query string is registered.
     - parameter query: Search string.
     - returns: true, if found.
     */
    public func lookup(_ query: String) -> Bool {
        return marisa_lookup(context, query) == 1
    }

    /**
     Saves dictionary into a file.
     - parameter path: Path to a file.
     */
    public func save(_ path: String) {
        marisa_save(context, path)
    }

    /**
     Reads dictionary from a file.
     - parameter path: Path to a file.
     */
    public func load(_ path: String) {
        marisa_load(context, path)
    }

    deinit {
        marisa_delete_context(context)
    }
}

// MARK: - Private

private final class SearchResults: Sequence {
    private let searchContext: UnsafeMutablePointer<marisa_search_context>

    init(context: UnsafeMutablePointer<marisa_context>, query: String, type: MarisaSearchType) {
        self.searchContext = marisa_search(context, query, type)
    }

    func makeIterator() -> AnyIterator<String> {
        return AnyIterator<String> {
            var buf: UnsafeMutablePointer<CChar>?
            var len: Int = 0
            guard marisa_search_next(self.searchContext, &buf, &len) == 1 else { return nil }
            guard len > 0 else { return nil }
            guard let b = buf else { return nil }

            return String(bytesNoCopy: b,
                          length: len,
                          encoding: .utf8,
                          freeWhenDone: false)
        }
    }

    deinit {
        marisa_delete_search_context(searchContext)
    }
}
