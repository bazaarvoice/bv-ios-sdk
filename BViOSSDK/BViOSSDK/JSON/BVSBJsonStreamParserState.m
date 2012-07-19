/*
 Copyright (c) 2010, Stig Brautaset.
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:

   Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

   Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

   Neither the name of the the author nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
 IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "BVSBJsonStreamParserState.h"
#import "BVSBJsonStreamParser.h"

#define SINGLETON \
+ (id)sharedInstance { \
    static id state; \
    if (!state) state = [[self alloc] init]; \
    return state; \
}

@implementation BVSBJsonStreamParserState

+ (id)sharedInstance { return nil; }

- (BOOL)parser:(BVSBJsonStreamParser*)parser shouldAcceptToken:(BVSBJson_token_t)token {
	return NO;
}

- (BVSBJsonStreamParserStatus)parserShouldReturn:(BVSBJsonStreamParser*)parser {
	return BVSBJsonStreamParserWaitingForData;
}

- (void)parser:(BVSBJsonStreamParser*)parser shouldTransitionTo:(BVSBJson_token_t)tok {}

- (BOOL)needKey {
	return NO;
}

- (NSString*)name {
	return @"<aaiie!>";
}

- (BOOL)isError {
    return NO;
}

@end

#pragma mark -

@implementation BVSBJsonStreamParserStateStart

SINGLETON

- (BOOL)parser:(BVSBJsonStreamParser*)parser shouldAcceptToken:(BVSBJson_token_t)token {
	return token == BVSBJson_token_array_start || token == BVSBJson_token_object_start;
}

- (void)parser:(BVSBJsonStreamParser*)parser shouldTransitionTo:(BVSBJson_token_t)tok {

	BVSBJsonStreamParserState *state = nil;
	switch (tok) {
		case BVSBJson_token_array_start:
			state = [BVSBJsonStreamParserStateArrayStart sharedInstance];
			break;

		case BVSBJson_token_object_start:
			state = [BVSBJsonStreamParserStateObjectStart sharedInstance];
			break;

		case BVSBJson_token_array_end:
		case BVSBJson_token_object_end:
			if (parser.supportMultipleDocuments)
				state = parser.state;
			else
				state = [BVSBJsonStreamParserStateComplete sharedInstance];
			break;

		case BVSBJson_token_eof:
			return;

		default:
			state = [BVSBJsonStreamParserStateError sharedInstance];
			break;
	}


	parser.state = state;
}

- (NSString*)name { return @"before outer-most array or object"; }

@end

#pragma mark -

@implementation BVSBJsonStreamParserStateComplete

SINGLETON

- (NSString*)name { return @"after outer-most array or object"; }

- (BVSBJsonStreamParserStatus)parserShouldReturn:(BVSBJsonStreamParser*)parser {
	return BVSBJsonStreamParserComplete;
}

@end

#pragma mark -

@implementation BVSBJsonStreamParserStateError

SINGLETON

- (NSString*)name { return @"in error"; }

- (BVSBJsonStreamParserStatus)parserShouldReturn:(BVSBJsonStreamParser*)parser {
	return BVSBJsonStreamParserError;
}

- (BOOL)isError {
    return YES;
}

@end

#pragma mark -

@implementation BVSBJsonStreamParserStateObjectStart

SINGLETON

- (NSString*)name { return @"at beginning of object"; }

- (BOOL)parser:(BVSBJsonStreamParser*)parser shouldAcceptToken:(BVSBJson_token_t)token {
	switch (token) {
		case BVSBJson_token_object_end:
		case BVSBJson_token_string:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

- (void)parser:(BVSBJsonStreamParser*)parser shouldTransitionTo:(BVSBJson_token_t)tok {
	parser.state = [BVSBJsonStreamParserStateObjectGotKey sharedInstance];
}

- (BOOL)needKey {
	return YES;
}

@end

#pragma mark -

@implementation BVSBJsonStreamParserStateObjectGotKey

SINGLETON

- (NSString*)name { return @"after object key"; }

- (BOOL)parser:(BVSBJsonStreamParser*)parser shouldAcceptToken:(BVSBJson_token_t)token {
	return token == BVSBJson_token_keyval_separator;
}

- (void)parser:(BVSBJsonStreamParser*)parser shouldTransitionTo:(BVSBJson_token_t)tok {
	parser.state = [BVSBJsonStreamParserStateObjectSeparator sharedInstance];
}

@end

#pragma mark -

@implementation BVSBJsonStreamParserStateObjectSeparator

SINGLETON

- (NSString*)name { return @"as object value"; }

- (BOOL)parser:(BVSBJsonStreamParser*)parser shouldAcceptToken:(BVSBJson_token_t)token {
	switch (token) {
		case BVSBJson_token_object_start:
		case BVSBJson_token_array_start:
		case BVSBJson_token_true:
		case BVSBJson_token_false:
		case BVSBJson_token_null:
		case BVSBJson_token_number:
		case BVSBJson_token_string:
			return YES;
			break;

		default:
			return NO;
			break;
	}
}

- (void)parser:(BVSBJsonStreamParser*)parser shouldTransitionTo:(BVSBJson_token_t)tok {
	parser.state = [BVSBJsonStreamParserStateObjectGotValue sharedInstance];
}

@end

#pragma mark -

@implementation BVSBJsonStreamParserStateObjectGotValue

SINGLETON

- (NSString*)name { return @"after object value"; }

- (BOOL)parser:(BVSBJsonStreamParser*)parser shouldAcceptToken:(BVSBJson_token_t)token {
	switch (token) {
		case BVSBJson_token_object_end:
		case BVSBJson_token_separator:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

- (void)parser:(BVSBJsonStreamParser*)parser shouldTransitionTo:(BVSBJson_token_t)tok {
	parser.state = [BVSBJsonStreamParserStateObjectNeedKey sharedInstance];
}


@end

#pragma mark -

@implementation BVSBJsonStreamParserStateObjectNeedKey

SINGLETON

- (NSString*)name { return @"in place of object key"; }

- (BOOL)parser:(BVSBJsonStreamParser*)parser shouldAcceptToken:(BVSBJson_token_t)token {
    return BVSBJson_token_string == token;
}

- (void)parser:(BVSBJsonStreamParser*)parser shouldTransitionTo:(BVSBJson_token_t)tok {
	parser.state = [BVSBJsonStreamParserStateObjectGotKey sharedInstance];
}

- (BOOL)needKey {
	return YES;
}

@end

#pragma mark -

@implementation BVSBJsonStreamParserStateArrayStart

SINGLETON

- (NSString*)name { return @"at array start"; }

- (BOOL)parser:(BVSBJsonStreamParser*)parser shouldAcceptToken:(BVSBJson_token_t)token {
	switch (token) {
		case BVSBJson_token_object_end:
		case BVSBJson_token_keyval_separator:
		case BVSBJson_token_separator:
			return NO;
			break;

		default:
			return YES;
			break;
	}
}

- (void)parser:(BVSBJsonStreamParser*)parser shouldTransitionTo:(BVSBJson_token_t)tok {
	parser.state = [BVSBJsonStreamParserStateArrayGotValue sharedInstance];
}

@end

#pragma mark -

@implementation BVSBJsonStreamParserStateArrayGotValue

SINGLETON

- (NSString*)name { return @"after array value"; }


- (BOOL)parser:(BVSBJsonStreamParser*)parser shouldAcceptToken:(BVSBJson_token_t)token {
	return token == BVSBJson_token_array_end || token == BVSBJson_token_separator;
}

- (void)parser:(BVSBJsonStreamParser*)parser shouldTransitionTo:(BVSBJson_token_t)tok {
	if (tok == BVSBJson_token_separator)
		parser.state = [BVSBJsonStreamParserStateArrayNeedValue sharedInstance];
}

@end

#pragma mark -

@implementation BVSBJsonStreamParserStateArrayNeedValue

SINGLETON

- (NSString*)name { return @"as array value"; }


- (BOOL)parser:(BVSBJsonStreamParser*)parser shouldAcceptToken:(BVSBJson_token_t)token {
	switch (token) {
		case BVSBJson_token_array_end:
		case BVSBJson_token_keyval_separator:
		case BVSBJson_token_object_end:
		case BVSBJson_token_separator:
			return NO;
			break;

		default:
			return YES;
			break;
	}
}

- (void)parser:(BVSBJsonStreamParser*)parser shouldTransitionTo:(BVSBJson_token_t)tok {
	parser.state = [BVSBJsonStreamParserStateArrayGotValue sharedInstance];
}

@end

