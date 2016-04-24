//
//  SVTranslateGateway.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "SVTranslateGateway.h"
#import "NSDictionary+DataValues.h"

static NSString * const SVMyMemoryAPITranslateURLString = @"http://api.mymemory.translated.net/";

@interface SVTranslateGateway ()

@property (nonatomic, strong) NSURLSessionDataTask *currentTask;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation SVTranslateGateway

+ (SVTranslateGateway *)sharedTranslateGateway {
    static SVTranslateGateway *_sharedTranslateGateway = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTranslateGateway = [[self alloc] initWithBaseURL:[NSURL URLWithString:SVMyMemoryAPITranslateURLString]];
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
    
    parameters[kQ] = word;
    parameters[kMt] = @(0);
    parameters[kOf] = kJson;
    parameters[kLangpair] = type == SVTranslateRusEng ? kRusEn : kEnRus;
    
    self.isLoading = YES;
    
    __weak SVTranslateGateway *weakSelf = self;
    
    self.currentTask = [self GET:kGet parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject translatedText]) {
            //The translation of the word is not found.
            successBlock(nil);
        } else {
            successBlock([responseObject translatedText]);
        }
        weakSelf.isLoading = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != -999) {
            weakSelf.isLoading = NO;
            failureBlock(error);
        }
    }];
}

@end
