//
//  SVTranslateGateway.h
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, SVTranslateType) {
    SVTranslateRusEng,
    SVTranslateEngRus,
};

typedef void (^SVDataManagerSuccessCompletionBlock)(NSString *translation);
typedef void (^SVDataManagerFailureCompletionBlock)(NSError *error);

@interface SVTranslateGateway : AFHTTPSessionManager

+ (SVTranslateGateway *)sharedTranslateGateway;
- (void)translateWord:(NSString *)word translateType:(SVTranslateType)type success:(SVDataManagerSuccessCompletionBlock)successBlock failure:(SVDataManagerFailureCompletionBlock)failureBlock;


@end
