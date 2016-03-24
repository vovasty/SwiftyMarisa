//  Marisa.swift
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

import Foundation

public class SearchResults : SequenceType {
    private let context: COpaquePointer
    private let query: String
    private var searchContext: COpaquePointer? = nil
    private let type: MarisaSearchType
    
    init(context: COpaquePointer, query: String, type: MarisaSearchType) {
        self.context = context
        self.query = query
        self.type = type
    }
    
    public func generate() -> AnyGenerator<String> {
        var buf: UnsafeMutablePointer<CChar> = nil
        var len: Int = 0
        
        let pointer = UnsafeMutablePointer<CChar>((self.query as NSString).UTF8String)
        
        searchContext = marisa_search(context, pointer, self.type);
        
        return AnyGenerator<String>{
            guard marisa_search_next(self.searchContext!, &buf, &len) == 1 else { return nil }
            return String(bytesNoCopy: buf, length: len, encoding: NSUTF8StringEncoding, freeWhenDone: false)
        }
    }
    
    deinit {
        if searchContext != nil {
            marisa_delete_search_context(searchContext!);
        }
    }
}


public class Marisa {
    private var context = marisa_create_context()
    private var searchCallback: ((String)->Bool)!
    
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
    public func build(@noescape builder: ((String)->Void)->Void) {
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
    public func search(query: String, _ type: MarisaSearchType) -> SearchResults {
        return SearchResults(context: context, query: query, type: type)
    }

    /**
     Checks whether or not a query string is registered.
     - parameter query: Search string.
     - returns: true, if found.
     */
    public func lookup(query: String) -> Bool {
        return marisa_lookup(context, query) == 1
    }
    
    /**
     Saves dictionary into a file.
     - parameter path: Path to a file.
     */
    public func save(path: String) {
        marisa_save(context, path)
    }

    /**
     Reads dictionary from a file.
     - parameter path: Path to a file.
     */
    public func load(path: String) {
        marisa_load(context, path)
    }
    
    deinit {
        marisa_delete_context(context)
    }
}