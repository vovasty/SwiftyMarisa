//  cmarisawrapper.h
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

#ifndef CMARISAWRAPPER_H
#define CMARISAWRAPPER_H

#include <marisa/trie.h>
#include <stdlib.h>
#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum _MarisaSearchType: int {
    MarisaSearchTypePrefix = 0,
    MarisaSearchTypePredictive = 1
} MarisaSearchType;

typedef unsigned long size_t;

typedef struct marisa_search_context {
    marisa::Trie  *trie;
    marisa::Agent  *agent;
    char *query;
    bool (marisa::Trie::*search)(marisa::Agent&) const;
} marisa_search_context;

typedef struct marisa_context {
    marisa::Trie  *trie;
    marisa::Keyset  *keyset;
} marisa_context;

// Inline implementations
inline marisa_context *marisa_create_context() {
    marisa_context *context = (marisa_context *)malloc(sizeof(marisa_context));
    context->keyset = new marisa::Keyset;
    context->trie = new marisa::Trie;
    return context;
}

inline void marisa_add_word(marisa_context *context, const char *word) {
    context->keyset->push_back(word);
}

inline void marisa_build_tree(marisa_context *context) {
    context->trie->build(*context->keyset);
}

inline int marisa_lookup(marisa_context *context, const char *query) {
    marisa::Agent agent;
    agent.set_query(query);
    return context->trie->lookup(agent);
}

inline marisa_search_context *marisa_search(marisa_context *context, const char *query, MarisaSearchType type) {
    marisa::Agent *agent = new marisa::Agent;
    marisa_search_context *search_context = (marisa_search_context *)malloc(sizeof(marisa_search_context));
    search_context->trie = context->trie;
    search_context->agent = agent;
    char* query_copy = (char *)malloc(strlen(query) + 1);
    strcpy(query_copy, query);
    search_context->query = query_copy;

    switch (type) {
        case MarisaSearchTypePrefix:
            search_context->search = &marisa::Trie::common_prefix_search;
            break;
        case MarisaSearchTypePredictive:
            search_context->search = &marisa::Trie::predictive_search;
            break;
    }

    agent->set_query(search_context->query);
    return search_context;
}

inline int marisa_search_next(marisa_search_context *context, char **result, size_t *len) {
    if ((*context->trie.*context->search)(*context->agent)) {
        *result = (char *)context->agent->key().ptr();
        *len = context->agent->key().length();
        return 1;
    } else {
        *result = NULL;
        *len = 0;
        return 0;
    }
}

inline void marisa_delete_search_context(marisa_search_context *context) {
    delete context->agent;
    free(context->query);
    free(context);
}

inline void marisa_load(marisa_context *context, const char *path) {
    context->trie->load(path);
}

inline void marisa_save(marisa_context *context, const char *path) {
    context->trie->save(path);
}

inline void marisa_delete_context(marisa_context *context) {
    delete context->keyset;
    delete context->trie;
    free(context);
}

#ifdef __cplusplus
}
#endif

#endif // CMARISAWRAPPER_H
