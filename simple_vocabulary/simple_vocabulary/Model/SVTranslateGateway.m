//
//  SVTranslateGateway.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "SVTranslateGateway.h"

static NSString * const MyMemoryAPITranslateURLString = @"http://api.mymemory.translated.net/";

@implementation SVTranslateGateway

+ (SVTranslateGateway *)sharedTranslateGateway {
    static SVTranslateGateway *_sharedTranslateGateway = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTranslateGateway = [[self alloc] initWithBaseURL:[NSURL URLWithString:MyMemoryAPITranslateURLString]];
    });
    
    return _sharedTranslateGateway;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

@end
