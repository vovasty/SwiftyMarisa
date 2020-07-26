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

#ifndef cmarisawrapper_h
#define cmarisawrapper_h

#ifdef __cplusplus
extern "C" {
#endif

    typedef enum _MarisaSearchType: int {
        MarisaSearchTypePrefix = 0,
        MarisaSearchTypePredictive = 1
    } MarisaSearchType;


    typedef unsigned long size_t;
    
    typedef struct marisa_context marisa_context;
    typedef struct marisa_search_context marisa_search_context;
    
    marisa_search_context *marisa_search(marisa_context *context, const char *query, MarisaSearchType type);
    
    int marisa_search_next(marisa_search_context *context, char **result, size_t *len);
    
    int marisa_lookup(marisa_context *context, const char *query);
    
    void marisa_delete_search_context(marisa_search_context *context);

    marisa_context *marisa_create_context();

    void marisa_add_word(marisa_context *context, const char *word);
    
    void marisa_build_tree(marisa_context *context);
    
    void marisa_load(marisa_context *context, const char *path);
    void marisa_save(marisa_context *context, const char *path);

    
    void marisa_delete_context(marisa_context *context);
#ifdef __cplusplus
}
#endif

#endif /* cmarisawrapper_h */
