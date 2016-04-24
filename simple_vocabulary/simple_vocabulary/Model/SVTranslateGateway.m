//
//  SVTranslateGateway.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "SVTranslateGateway.h"

static NSString * const MyMemoryAPITranslateURLString = @"http://api.mymemory.translated.net/";

@interface SVTranslateGateway ()

@property (nonatomic, strong) NSURLSessionDataTask *currentTask;

@property (nonatomic, assign) BOOL isLoading;

@end

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
        self.isLoading = NO;
    }
    
    return self;
}

- (void)translateWord:(NSString *)word
        translateType:(SVTranslateType)type
              success:(SVDataManagerSuccessCompletionBlock)successBlock
              failure:(SVDataManagerFailureCompletionBlock)failureBlock {
    if (self.isLoading) {
        [self.currentTask cancel];
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"q"] = word;
    parameters[@"mt"] = @(0);
    parameters[@"of"] = @"json";
    parameters[@"langpair"] = type == SVTranslateRusEng ? @"rus|en" : @"en|rus";
    
    self.isLoading = YES;
    
    __weak SVTranslateGateway *weakSelf = self;
    
    self.currentTask = [self GET:@"get" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject[@"responseData"][@"translatedText"]);
        
        weakSelf.isLoading = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"*** Error: %@", [error localizedDescription]);
        
        weakSelf.isLoading = NO;
        
    }];
}

@end
