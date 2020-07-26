SwiftyMarisa is a swift wrapper for [marisa-trie](https://marisa-trie.googlecode.com/).

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 11.0+

## Description

Matching Algorithm with Recursively Implemented StorAge (MARISA) is a static and space-efficient trie data structure. And libmarisa is a C++ library to provide an implementation of MARISA. Also, the package of libmarisa contains a set of command line tools for building and operating a MARISA-based dictionary.

A MARISA-based dictionary supports not only lookup but also reverse lookup, common prefix search and predictive search.

Lookup is to check whether or not a given string exists in a dictionary.
Reverse lookup is to restore a key from its ID.
Common prefix search is to find keys from prefixes of a given string.
Predictive search is to find keys starting with a given string.
The biggest advantage of libmarisa is that its dictionary size is considerably more compact than others. See below for the dictionary size of other implementations.

Input
Source: enwiki-20121101-all-titles-in-ns0.gz
Contents: all page titles of English Wikipedia (Nov. 2012)
Number of keys: 9,805,576
Total size: 200,435,403 bytes (plain) / 54,933,690 bytes (gzipped)

## Usage

### Building dictionary

```swift
import Marisa

let trie = Marisa()

trie.build { (builder) -> Void in
    builder("U")
    builder("US")
    builder("USA")
}
```

### Search

```swift
for entry in trie.search("US", .predictive) {
     print(entry)
}
```

### Lookup

```swift
print(trie.lookup("US"))
print(trie.lookup("UK"))
```
