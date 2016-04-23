//
//  SVLocalDatabaseManager.h
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVLocalDatabaseManager : NSObject

- (void)insertToLocalDatabaseTranslationInfo:(NSDictionary *)translationInfo;
- (NSArray *)fetchTranslationsWithPredicate:(NSPredicate *)predicate;
- (NSArray *)fetchAllTranslations;

@end
