//  wrapper.c
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

#include "wrapper.h"
#include <marisa/trie.h>
#include <stdlib.h>
#include <string.h>

extern "C" {
    
    typedef struct marisa_search_context {
        marisa::Trie  *trie;
        marisa::Agent  *agent;
        bool (marisa::Trie::*search)(marisa::Agent&) const;
    } marisa_search_context;

    typedef struct marisa_context {
        marisa::Trie  *trie;
        marisa::Keyset  *keyset;
    } marisa_context;

    
    marisa_context *marisa_create_context() {
        marisa_context *context = (marisa_context *)malloc(sizeof(marisa_context));
        context->keyset = new marisa::Keyset;
        context->trie = new marisa::Trie;
        
        return context;
    }
    
    
    void marisa_add_word(marisa_context *context, const char *word) {
        context->keyset->push_back(word);
    }
    
    void marisa_build_tree(marisa_context *context) {
        context->trie->build(*context->keyset);
    }
    
    
    int marisa_lookup(marisa_context *context, const char *query) {
        marisa::Agent agent;
        marisa::Trie *trie = context->trie;
        
        agent.set_query(query);
        
        return trie->lookup(agent);
    }
    
    marisa_search_context *marisa_search(marisa_context *context, char *query, MarisaSearchType type) {
        marisa::Agent *agent = new marisa::Agent;
        marisa::Trie *trie = context->trie;
        
        marisa_search_context *search_context = (marisa_search_context *)malloc(sizeof(marisa_search_context));
        search_context->trie = trie;
        search_context->agent = agent;
        
        switch (type) {
            case MarisaSearchTypePrefix:
                search_context->search = &marisa::Trie::common_prefix_search;
                break;
            case MarisaSearchTypePredictive:
                search_context->search = &marisa::Trie::predictive_search;
                break;
        }
        
        agent->set_query(query);
        
        return search_context;
    }
    
    int marisa_search_next(marisa_search_context *context, char **result, size_t *len) {
        marisa::Agent *agent = context->agent;
        
        if ( (*context->trie.*context->search)(*agent) ) {
            *result = (char *)agent->key().ptr();
            *len = agent->key().length();
            return 1;
        }
        else {
            *result = NULL;
            *len = 0;
            return 0;
        }
    }
    
    void marisa_delete_search_context(marisa_search_context *context) {
        delete (marisa::Agent*)context->agent;
        free(context);
    }

    void marisa_load(marisa_context *context, const char *path) {
        context->trie->load(path);
    }

    void marisa_save(marisa_context *context, const char *path) {
        context->trie->save(path);
    }

    void marisa_delete_context(marisa_context *context) {
        delete context->keyset;
        delete context->trie;
        free(context);
    }
    
}