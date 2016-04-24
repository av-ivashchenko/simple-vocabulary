//
//  SVLocalDatabaseManager.h
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SVLocalDatabaseManagerInsertCompletionBlock)(NSError *error);

@interface SVLocalDatabaseManager : NSObject

- (void)insertToLocalDatabaseTranslationInfo:(NSDictionary *)translationInfo
                                  completion:(SVLocalDatabaseManagerInsertCompletionBlock)completion;

- (NSArray *)fetchTranslationsWithPredicate:(NSPredicate *)predicate;
- (NSArray *)fetchAllTranslations;

@end
