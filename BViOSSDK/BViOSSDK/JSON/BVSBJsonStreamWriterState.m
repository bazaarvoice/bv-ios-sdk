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

#import "BVSBJsonStreamWriterState.h"
#import "BVSBJsonStreamWriter.h"

#define SINGLETON \
+ (id)sharedInstance { \
    static id state; \
    if (!state) state = [[self alloc] init]; \
    return state; \
}


@implementation BVSBJsonStreamWriterState
+ (id)sharedInstance { return nil; }
- (BOOL)isInvalidState:(BVSBJsonStreamWriter*)writer { return NO; }
- (void)appendSeparator:(BVSBJsonStreamWriter*)writer {}
- (BOOL)expectingKey:(BVSBJsonStreamWriter*)writer { return NO; }
- (void)transitionState:(BVSBJsonStreamWriter *)writer {}
- (void)appendWhitespace:(BVSBJsonStreamWriter*)writer {
	[writer appendBytes:"\n" length:1];
	for (NSUInteger i = 0; i < writer.stateStack.count; i++)
	    [writer appendBytes:"  " length:2];
}
@end

@implementation BVSBJsonStreamWriterStateObjectStart

SINGLETON

- (void)transitionState:(BVSBJsonStreamWriter *)writer {
	writer.state = [BVSBJsonStreamWriterStateObjectValue sharedInstance];
}
- (BOOL)expectingKey:(BVSBJsonStreamWriter *)writer {
	writer.error = @"JSON object key must be string";
	return YES;
}
@end

@implementation BVSBJsonStreamWriterStateObjectKey

SINGLETON

- (void)appendSeparator:(BVSBJsonStreamWriter *)writer {
	[writer appendBytes:"," length:1];
}
@end

@implementation BVSBJsonStreamWriterStateObjectValue

SINGLETON

- (void)appendSeparator:(BVSBJsonStreamWriter *)writer {
	[writer appendBytes:":" length:1];
}
- (void)transitionState:(BVSBJsonStreamWriter *)writer {
    writer.state = [BVSBJsonStreamWriterStateObjectKey sharedInstance];
}
- (void)appendWhitespace:(BVSBJsonStreamWriter *)writer {
	[writer appendBytes:" " length:1];
}
@end

@implementation BVSBJsonStreamWriterStateArrayStart

SINGLETON

- (void)transitionState:(BVSBJsonStreamWriter *)writer {
    writer.state = [BVSBJsonStreamWriterStateArrayValue sharedInstance];
}
@end

@implementation BVSBJsonStreamWriterStateArrayValue

SINGLETON

- (void)appendSeparator:(BVSBJsonStreamWriter *)writer {
	[writer appendBytes:"," length:1];
}
@end

@implementation BVSBJsonStreamWriterStateStart

SINGLETON


- (void)transitionState:(BVSBJsonStreamWriter *)writer {
    writer.state = [BVSBJsonStreamWriterStateComplete sharedInstance];
}
- (void)appendSeparator:(BVSBJsonStreamWriter *)writer {
}
@end

@implementation BVSBJsonStreamWriterStateComplete

SINGLETON

- (BOOL)isInvalidState:(BVSBJsonStreamWriter*)writer {
	writer.error = @"Stream is closed";
	return YES;
}
@end

@implementation BVSBJsonStreamWriterStateError

SINGLETON

@end

