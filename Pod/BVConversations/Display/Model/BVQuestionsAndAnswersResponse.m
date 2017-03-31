//
//  QuestionsAndAnswersResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionsAndAnswersResponse.h"
#import "BVConversationsInclude.h"
#import "BVQuestion.h"
#import "BVNullHelper.h"

@implementation BVQuestionsAndAnswersResponse

-(id)createResult:(NSDictionary *)raw includes:(BVConversationsInclude *)includes {
    return [[BVQuestion alloc] initWithApiResponse:raw includes:includes];
}

@end
