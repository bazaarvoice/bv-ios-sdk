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

#import "BVSBJsonStreamParserAdapter.h"

@interface BVSBJsonStreamParserAdapter ()

- (void)pop;
- (void)parser:(BVSBJsonStreamParser*)parser found:(id)obj;

@end



@implementation BVSBJsonStreamParserAdapter

@synthesize delegate;
@synthesize levelsToSkip;

#pragma mark Housekeeping

- (id)init {
	self = [super init];
	if (self) {
		keyStack = [[NSMutableArray alloc] initWithCapacity:32];
		stack = [[NSMutableArray alloc] initWithCapacity:32];
		
		currentType = BVSBJsonStreamParserAdapterNone;
	}
	return self;
}	


#pragma mark Private methods

- (void)pop {
	[stack removeLastObject];
	array = nil;
	dict = nil;
	currentType = BVSBJsonStreamParserAdapterNone;
	
	id value = [stack lastObject];
	
	if ([value isKindOfClass:[NSArray class]]) {
		array = value;
		currentType = BVSBJsonStreamParserAdapterArray;
	} else if ([value isKindOfClass:[NSDictionary class]]) {
		dict = value;
		currentType = BVSBJsonStreamParserAdapterObject;
	}
}

- (void)parser:(BVSBJsonStreamParser*)parser found:(id)obj {
	NSParameterAssert(obj);
	
	switch (currentType) {
		case BVSBJsonStreamParserAdapterArray:
			[array addObject:obj];
			break;

		case BVSBJsonStreamParserAdapterObject:
			NSParameterAssert(keyStack.count);
			[dict setObject:obj forKey:[keyStack lastObject]];
			[keyStack removeLastObject];
			break;
			
		case BVSBJsonStreamParserAdapterNone:
			if ([obj isKindOfClass:[NSArray class]]) {
				[delegate parser:parser foundArray:obj];
			} else {
				[delegate parser:parser foundObject:obj];
			}				
			break;

		default:
			break;
	}
}


#pragma mark Delegate methods

- (void)parserFoundObjectStart:(BVSBJsonStreamParser*)parser {
	if (++depth > self.levelsToSkip) {
		dict = [NSMutableDictionary new];
		[stack addObject:dict];
		currentType = BVSBJsonStreamParserAdapterObject;
	}
}

- (void)parser:(BVSBJsonStreamParser*)parser foundObjectKey:(NSString*)key_ {
	[keyStack addObject:key_];
}

- (void)parserFoundObjectEnd:(BVSBJsonStreamParser*)parser {
	if (depth-- > self.levelsToSkip) {
		id value = dict;
		[self pop];
		[self parser:parser found:value];
	}
}

- (void)parserFoundArrayStart:(BVSBJsonStreamParser*)parser {
	if (++depth > self.levelsToSkip) {
		array = [NSMutableArray new];
		[stack addObject:array];
		currentType = BVSBJsonStreamParserAdapterArray;
	}
}

- (void)parserFoundArrayEnd:(BVSBJsonStreamParser*)parser {
	if (depth-- > self.levelsToSkip) {
		id value = array;
		[self pop];
		[self parser:parser found:value];
	}
}

- (void)parser:(BVSBJsonStreamParser*)parser foundBoolean:(BOOL)x {
	[self parser:parser found:[NSNumber numberWithBool:x]];
}

- (void)parserFoundNull:(BVSBJsonStreamParser*)parser {
	[self parser:parser found:[NSNull null]];
}

- (void)parser:(BVSBJsonStreamParser*)parser foundNumber:(NSNumber*)num {
	[self parser:parser found:num];
}

- (void)parser:(BVSBJsonStreamParser*)parser foundString:(NSString*)string {
	[self parser:parser found:string];
}

@end
