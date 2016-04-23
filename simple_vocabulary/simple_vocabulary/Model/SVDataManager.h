//
//  SVDataManager.h
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SVDataManagerDelegate <NSObject>

- (void)translateEndedWithError:(NSString *)error;

@end

@interface SVDataManager : NSObject

@property (nonatomic, weak) id<SVDataManagerDelegate> delegate;

- (void)translateWord:(NSString *)word;

@end
