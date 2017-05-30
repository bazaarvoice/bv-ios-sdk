//
//  BVUploadablePhoto.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVUploadablePhoto.h"
#import "BVConversationsRequest.h"
#import "BVSDKManager.h"
#import "BVSubmissionErrorResponse.h"
#import "BVAnalyticsManager.h"
#import "BVSDKConfiguration.h"

@interface BVUploadablePhoto()

@property (readwrite) UIImage* _Nonnull photo;
@property (readwrite) NSString* _Nullable photoCaption;

@end

@implementation BVUploadablePhoto

-(nonnull instancetype)initWithPhoto:(nonnull UIImage*)photo photoCaption:(nullable NSString*)caption {
    self = [super init];
    if(self){
        self.photo = photo;
        self.photoCaption = caption;
    }
    return self;
}

-(NSString*)BVPhotoContentTypeToString:(BVPhotoContentType)type {
    switch (type) {
        case BVPhotoContentTypeReview: return @"review";
        case BVPhotoContentTypeAnswer: return @"answer";
        case BVPhotoContentTypeQuestion: return @"question";
        case BVPhotoContentTypeComment: return @"review_comment";
    }
}

-(void)uploadForContentType:(BVPhotoContentType)type success:(nonnull PhotoUploadCompletion)success failure:(nonnull PhotoUploadFailure)failure {
    
    NSString* urlString = [NSString stringWithFormat:@"%@uploadphoto.json", [BVConversationsRequest commonEndpoint]];
    NSURL* url = [NSURL URLWithString:urlString];
    
    // create request
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    // add multipart form data
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"----------------------------f3a1ba9c57bd";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

    [self appendKey:@"apiversion" value:@"5.4" toMultipartData:body withBoundary:boundary];
    [self appendKey:@"passkey" value:[self getPasskey] toMultipartData:body withBoundary:boundary];
    [self appendKey:@"contenttype" value:[self BVPhotoContentTypeToString:type] toMultipartData:body withBoundary:boundary];
    [self appendKey:@"photo" data: UIImagePNGRepresentation(self.photo) toMultipartData:body withBoundary:boundary];
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    
    NSURLSession* session = [NSURLSession sharedSession];
    
    [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"POST: %@\n with BODY: %@", urlString, body]];
    
    NSURLSessionDataTask *sessionTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable httpError) {
        
        @try {
            
            // Attempt to get photoUrl from response.
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response; // This dataTask is used with only HTTP requests.
            NSInteger statusCode = httpResponse.statusCode;
            NSError* jsonParsingError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParsingError];
            NSString* photoUrl = json[@"Photo"][@"Sizes"][@"normal"][@"Url"]; // fails gracefully
            // Generate bazaarvoice-specific error response, if applicable.
            BVSubmissionErrorResponse* errorResponse = [[BVSubmissionErrorResponse alloc] initWithApiResponse:json]; //fail gracefully
            
            [[BVLogger sharedLogger] verbose:[NSString stringWithFormat:@"RESPONSE: %@ (%ld)", json, (long)statusCode]];
            
            if (photoUrl) {
                // successful response!
                success(photoUrl);
            }
            else if (httpError) {
                // network error was generated
                [[BVLogger sharedLogger] printError:httpError];
                failure(@[httpError]);
            }
            else if(statusCode >= 300){
                // HTTP status code indicates failure
                NSError* statusError = [NSError errorWithDomain:@"com.bazaarvoice.bvsdk" code:BV_ERROR_NETWORK_FAILED userInfo:@{NSLocalizedDescriptionKey:@"Photo upload failed."}];
                [[BVLogger sharedLogger] printError:statusError];
                failure(@[statusError]);
            }
            else if (jsonParsingError) {
                // json parsing failed
                [[BVLogger sharedLogger] printError:jsonParsingError];
                failure(@[jsonParsingError]);
            }
            else if (errorResponse) {
                // bazaarvoice-specific error occured -- ex: API key is invalid
                NSArray<NSError*>* errors = [errorResponse toNSErrors];
                [[BVLogger sharedLogger] printErrors:errors];
                failure(errors);
            }
            else {
                // Unknown error -- ex: api responded successfully but did not have photo URL
                NSError* error = [NSError errorWithDomain:@"com.bazaarvoice.bvsdk" code:BV_ERROR_PARSING_FAILED userInfo:@{NSLocalizedDescriptionKey:@"Photo upload failed."}];
                [[BVLogger sharedLogger] printError:error];
                failure(@[error]);
            }
            
        }
        @catch (NSException *exception) {
            NSError* error = [NSError errorWithDomain:BVErrDomain code:BV_ERROR_UNKNOWN userInfo:@{NSLocalizedDescriptionKey:@"An unknown parsing error occurred."}];
            [[BVLogger sharedLogger] printError:error];
            failure(@[error]);
        }
        
        
    }];
    
    // start photo upload
    [sessionTask resume];

}


- (void)appendKey:(NSString *)key value:(NSString *)value toMultipartData:(NSMutableData *)body withBoundary:(NSString *)boundary {
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)appendKey:(NSString *)key data:(NSData *)data toMultipartData:(NSMutableData *)body withBoundary:(NSString *)boundary {
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"upload\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:data]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString * _Nonnull)getPasskey{
    return [BVSDKManager sharedManager].configuration.apiKeyConversations;
}

@end
