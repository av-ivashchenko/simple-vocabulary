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

- (void)translateWord:(NSString *)word
        translateType:(SVTranslateType)type
              success:(SVDataManagerSuccessCompletionBlock)successBlock
              failure:(SVDataManagerFailureCompletionBlock)failureBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"q"] = word;
    parameters[@"mt"] = @(0);
    parameters[@"of"] = @"json";
    parameters[@"langpair"] = type == SVTranslateRusEng ? @"rus|en" : @"en|rus";
    
    [self GET:@"get" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"*** Success: %@", responseObject);
        successBlock(responseObject[@"responseData"][@"translatedText"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"*** Error: %@", [error localizedDescription]);
    }];
}

@end
