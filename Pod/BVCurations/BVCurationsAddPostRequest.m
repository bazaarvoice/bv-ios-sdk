//
//  BVCurationsAddPostRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCurationsAddPostRequest.h"

@implementation BVCurationsAddPostRequest

- (id)initWithGroups:(NSArray<NSString *>*)groups withAuthorAlias:(NSString *)alias withToken:(NSString *)token withText:(NSString *)text{
    
    self = [super init];
    if (self){
        _groups = groups;
        _alias = alias;
        _token = token;
        _text = text;
        _unixTimeStamp = 0;
        _latitude = 0;
        _longitude = 0;
        
        _photos = [NSArray array];
        _links = [NSArray array];
    }
    
    return self;
    
}

- (id)initWithGroups:(NSArray<NSString *>*)groups withAuthorAlias:(NSString *)alias withToken:(NSString *)token withText:(NSString *)text withImage:(UIImage *)image{
    
    self = [self initWithGroups:groups withAuthorAlias:alias withToken:token withText:text];
    if (self){
        _image = image;
    }
    
    return self;
}


- (NSDictionary *)toDictionary {
    
    // Create the dictionary
    
    NSMutableDictionary *authorDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.alias, @"alias", self.token, @"token", nil]; // author dict
    
    if (self.authorAvatarURL){
        [authorDict setObject:self.authorAvatarURL forKey:@"avatar"];
    }
    
    if (self.authorProfileURL){
        [authorDict setObject:self.authorProfileURL forKey:@"profile"];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.groups, @"groups", authorDict, @"author", self.text, @"text", nil];
    
    // Serialize the dictionary
    
    if (self.tags){
        [params setObject:self.tags forKey:@"tags"];
    }
    
    if (self.permalink){
        [params setObject:self.permalink forKey:@"permalink"];
    }
    
    if (self.place){
        [params setObject:self.place forKey:@"place"];
    }
    
    if (self.teaser){
        [params setObject:self.teaser forKey:@"teaser"];
    }
    
    if (self.unixTimeStamp > 0){
        [params setObject:[NSNumber numberWithDouble:self.unixTimeStamp]forKey:@"timestamp"];
    }
    
    if (self.longitude != 0 && self.latitude != 0){
        
        NSNumber *longNum = [NSNumber numberWithDouble:self.longitude];
        NSNumber *latNum = [NSNumber numberWithDouble:self.latitude];
        
        NSDictionary *coordinatesDict = [NSDictionary dictionaryWithObjectsAndKeys:latNum, @"x", longNum, @"y", nil];
        
        [params setObject:coordinatesDict forKey:@"coordinates"];
    }

    if (self.links.count > 0){
        NSMutableArray *linksArray = [NSMutableArray array];
        for (NSString *link in self.links){
            [linksArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:link, @"url", nil]];
        }
        
        [params setObject:linksArray forKey:@"links"];

    }
    
    if (self.photos.count > 0){
        NSMutableArray *photosArray = [NSMutableArray array];
        for (NSString *photo in self.photos){
            [photosArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:photo, @"remote_url", nil]];
        }
       
        [params setObject:photosArray forKey:@"photos"];
    }
    
    return params;
    
}

- (NSData *)serializeParameters {
    
    NSDictionary *paramsDict = [self toDictionary];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:paramsDict options:kNilOptions error:&error];
    
    if (error){
        
        return nil;
    }
    
    return data;
    
}

- (NSString *)description {
    
    return [[NSString alloc] initWithData:self.serializeParameters encoding:NSUTF8StringEncoding];
    
}


@end
