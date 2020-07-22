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

import Foundation

open class SearchResults: Sequence {
    fileprivate let context: OpaquePointer
    fileprivate let query: String
    fileprivate var searchContext: OpaquePointer?
    fileprivate let type: MarisaSearchType

    init(context: OpaquePointer, query: String, type: MarisaSearchType) {
        self.context = context
        self.query = query
        self.type = type
    }

    open func makeIterator() -> AnyIterator<String> {
        var buf: UnsafeMutablePointer<CChar>?
        var len: Int = 0

        let pointer = UnsafeMutablePointer<CChar>(mutating: (query as NSString).utf8String)

        searchContext = marisa_search(context, pointer, type)

        return AnyIterator<String> {
            guard marisa_search_next(self.searchContext!, &buf, &len) == 1 else { return nil }

            return String(bytesNoCopy: buf!,
                          length: len,
                          encoding: String.Encoding.utf8,
                          freeWhenDone: false)
        }
    }

    deinit {
        if searchContext != nil {
            marisa_delete_search_context(searchContext!)
        }
    }
}

open class Marisa {
    private var context = marisa_create_context()
    private var searchCallback: ((String) -> Bool)!

    public init() {}

    /**
     Builds dictionary.
     - parameter builder: Closure with builder parameter. Builder accepts string parameter.

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
    open func build(_ builder: ((String) -> Void) -> Void) {
        let b: (String) -> Void = { marisa_add_word(self.context, $0) }
        builder(b)
        marisa_build_tree(context)
    }

    /**
     Searches keys from the possible prefixes of a query string.
     - parameter query: Search string.
     - parameter type: Search type.
        - Prefix: Searches keys from the possible prefixes of a query string.
        - Predictive: Searches keys starting with a query string
     - returns: Sequence.
     */
    open func search(_ query: String, _ type: MarisaSearchType) -> SearchResults {
        return SearchResults(context: context!, query: query, type: type)
    }

    /**
     Checks whether or not a query string is registered.
     - parameter query: Search string.
     - returns: true, if found.
     */
    open func lookup(_ query: String) -> Bool {
        return marisa_lookup(context, query) == 1
    }

    /**
     Saves dictionary into a file.
     - parameter path: Path to a file.
     */
    open func save(_ path: String) {
        marisa_save(context, path)
    }

    /**
     Reads dictionary from a file.
     - parameter path: Path to a file.
     */
    open func load(_ path: String) {
        marisa_load(context, path)
    }

    deinit {
        marisa_delete_context(context)
    }
}
