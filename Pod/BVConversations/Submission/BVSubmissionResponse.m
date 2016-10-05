//
//  SubmissionResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionResponse.h"
#import "BVNullHelper.h"
#import "BVFormField.h"

@implementation BVSubmissionResponse

-(nonnull instancetype)initWithApiResponse:(NSDictionary*)apiResponse {
    self = [super init];
    if(self){
        
        SET_IF_NOT_NULL(self.locale, apiResponse[@"Locale"])
        SET_IF_NOT_NULL(self.submissionId, apiResponse[@"SubmissionId"])
        SET_IF_NOT_NULL(self.typicalHoursToPost, apiResponse[@"TypicalHoursToPost"])
        SET_IF_NOT_NULL(self.authorSubmissionToken, apiResponse[@"AuthorSubmissionToken"])
        
        NSMutableDictionary *tmpFields = [NSMutableDictionary dictionary];

        NSDictionary *data = [apiResponse objectForKey:@"Data"];
        if (data){
            NSDictionary *fields = [data objectForKey:@"Fields"];
            
            for (NSDictionary *fieldDict in [fields allValues]){
                BVFormField *formField = [[BVFormField alloc] initWithFormFieldDictionary:fieldDict];
                [tmpFields setObject:formField forKey:formField.identifier];
            }
            
            self.formFields = [NSDictionary dictionaryWithDictionary:tmpFields];
            
        }
        
    }
    return self;
}

@end
