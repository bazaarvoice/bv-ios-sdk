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

#import "GCJsonStreamParserState.h"
#import "GCJsonStreamParser.h"

#define SINGLETON \
+ (id)sharedInstance { \
    static id state; \
    if (!state) state = [[self alloc] init]; \
    return state; \
}

@implementation GCJsonStreamParserState

+ (id)sharedInstance { return nil; }

- (BOOL)parser:(GCJsonStreamParser*)parser shouldAcceptToken:(GCJson_token_t)token {
	return NO;
}

- (GCJsonStreamParserStatus)parserShouldReturn:(GCJsonStreamParser*)parser {
	return GCJsonStreamParserWaitingForData;
}

- (void)parser:(GCJsonStreamParser*)parser shouldTransitionTo:(GCJson_token_t)tok {}

- (BOOL)needKey {
	return NO;
}

- (NSString*)name {
	return @"<aaiie!>";
}

@end

#pragma mark -

@implementation GCJsonStreamParserStateStart

SINGLETON

- (BOOL)parser:(GCJsonStreamParser*)parser shouldAcceptToken:(GCJson_token_t)token {
	return token == GCJson_token_array_start || token == GCJson_token_object_start;
}

- (void)parser:(GCJsonStreamParser*)parser shouldTransitionTo:(GCJson_token_t)tok {

	GCJsonStreamParserState *state = nil;
	switch (tok) {
		case GCJson_token_array_start:
			state = [GCJsonStreamParserStateArrayStart sharedInstance];
			break;

		case GCJson_token_object_start:
			state = [GCJsonStreamParserStateObjectStart sharedInstance];
			break;

		case GCJson_token_array_end:
		case GCJson_token_object_end:
			if (parser.supportMultipleDocuments)
				state = parser.state;
			else
				state = [GCJsonStreamParserStateComplete sharedInstance];
			break;

		case GCJson_token_eof:
			return;

		default:
			state = [GCJsonStreamParserStateError sharedInstance];
			break;
	}


	parser.state = state;
}

- (NSString*)name { return @"before outer-most array or object"; }

@end

#pragma mark -

@implementation GCJsonStreamParserStateComplete

SINGLETON

- (NSString*)name { return @"after outer-most array or object"; }

- (GCJsonStreamParserStatus)parserShouldReturn:(GCJsonStreamParser*)parser {
	return GCJsonStreamParserComplete;
}

@end

#pragma mark -

@implementation GCJsonStreamParserStateError

SINGLETON

- (NSString*)name { return @"in error"; }

- (GCJsonStreamParserStatus)parserShouldReturn:(GCJsonStreamParser*)parser {
	return GCJsonStreamParserError;
}

@end

#pragma mark -

@implementation GCJsonStreamParserStateObjectStart

SINGLETON

- (NSString*)name { return @"at beginning of object"; }

- (BOOL)parser:(GCJsonStreamParser*)parser shouldAcceptToken:(GCJson_token_t)token {
	switch (token) {
		case GCJson_token_object_end:
		case GCJson_token_string:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

- (void)parser:(GCJsonStreamParser*)parser shouldTransitionTo:(GCJson_token_t)tok {
	parser.state = [GCJsonStreamParserStateObjectGotKey sharedInstance];
}

- (BOOL)needKey {
	return YES;
}

@end

#pragma mark -

@implementation GCJsonStreamParserStateObjectGotKey

SINGLETON

- (NSString*)name { return @"after object key"; }

- (BOOL)parser:(GCJsonStreamParser*)parser shouldAcceptToken:(GCJson_token_t)token {
	return token == GCJson_token_keyval_separator;
}

- (void)parser:(GCJsonStreamParser*)parser shouldTransitionTo:(GCJson_token_t)tok {
	parser.state = [GCJsonStreamParserStateObjectSeparator sharedInstance];
}

@end

#pragma mark -

@implementation GCJsonStreamParserStateObjectSeparator

SINGLETON

- (NSString*)name { return @"as object value"; }

- (BOOL)parser:(GCJsonStreamParser*)parser shouldAcceptToken:(GCJson_token_t)token {
	switch (token) {
		case GCJson_token_object_start:
		case GCJson_token_array_start:
		case GCJson_token_true:
		case GCJson_token_false:
		case GCJson_token_null:
		case GCJson_token_number:
		case GCJson_token_string:
			return YES;
			break;

		default:
			return NO;
			break;
	}
}

- (void)parser:(GCJsonStreamParser*)parser shouldTransitionTo:(GCJson_token_t)tok {
	parser.state = [GCJsonStreamParserStateObjectGotValue sharedInstance];
}

@end

#pragma mark -

@implementation GCJsonStreamParserStateObjectGotValue

SINGLETON

- (NSString*)name { return @"after object value"; }

- (BOOL)parser:(GCJsonStreamParser*)parser shouldAcceptToken:(GCJson_token_t)token {
	switch (token) {
		case GCJson_token_object_end:
		case GCJson_token_separator:
			return YES;
			break;
		default:
			return NO;
			break;
	}
}

- (void)parser:(GCJsonStreamParser*)parser shouldTransitionTo:(GCJson_token_t)tok {
	parser.state = [GCJsonStreamParserStateObjectNeedKey sharedInstance];
}


@end

#pragma mark -

@implementation GCJsonStreamParserStateObjectNeedKey

SINGLETON

- (NSString*)name { return @"in place of object key"; }

- (BOOL)parser:(GCJsonStreamParser*)parser shouldAcceptToken:(GCJson_token_t)token {
    return GCJson_token_string == token;
}

- (void)parser:(GCJsonStreamParser*)parser shouldTransitionTo:(GCJson_token_t)tok {
	parser.state = [GCJsonStreamParserStateObjectGotKey sharedInstance];
}

- (BOOL)needKey {
	return YES;
}

@end

#pragma mark -

@implementation GCJsonStreamParserStateArrayStart

SINGLETON

- (NSString*)name { return @"at array start"; }

- (BOOL)parser:(GCJsonStreamParser*)parser shouldAcceptToken:(GCJson_token_t)token {
	switch (token) {
		case GCJson_token_object_end:
		case GCJson_token_keyval_separator:
		case GCJson_token_separator:
			return NO;
			break;

		default:
			return YES;
			break;
	}
}

- (void)parser:(GCJsonStreamParser*)parser shouldTransitionTo:(GCJson_token_t)tok {
	parser.state = [GCJsonStreamParserStateArrayGotValue sharedInstance];
}

@end

#pragma mark -

@implementation GCJsonStreamParserStateArrayGotValue

SINGLETON

- (NSString*)name { return @"after array value"; }


- (BOOL)parser:(GCJsonStreamParser*)parser shouldAcceptToken:(GCJson_token_t)token {
	return token == GCJson_token_array_end || token == GCJson_token_separator;
}

- (void)parser:(GCJsonStreamParser*)parser shouldTransitionTo:(GCJson_token_t)tok {
	if (tok == GCJson_token_separator)
		parser.state = [GCJsonStreamParserStateArrayNeedValue sharedInstance];
}

@end

#pragma mark -

@implementation GCJsonStreamParserStateArrayNeedValue

SINGLETON

- (NSString*)name { return @"as array value"; }


- (BOOL)parser:(GCJsonStreamParser*)parser shouldAcceptToken:(GCJson_token_t)token {
	switch (token) {
		case GCJson_token_array_end:
		case GCJson_token_keyval_separator:
		case GCJson_token_object_end:
		case GCJson_token_separator:
			return NO;
			break;

		default:
			return YES;
			break;
	}
}

- (void)parser:(GCJsonStreamParser*)parser shouldTransitionTo:(GCJson_token_t)tok {
	parser.state = [GCJsonStreamParserStateArrayGotValue sharedInstance];
}

@end

