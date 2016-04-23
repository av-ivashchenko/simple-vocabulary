//
//  SVLocalDatabaseManager.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "SVLocalDatabaseManager.h"

#import "TranslationInfo.h"

@implementation SVLocalDatabaseManager

- (void)insertToLocalDatabaseTranslationInfo:(NSDictionary *)translationInfo {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
         [TranslationInfo MR_importFromObject:translationInfo inContext:localContext];
    }];
}

- (NSArray *)fetchAllTranslations {
    return [TranslationInfo MR_findAll];
}

- (NSArray *)fetchTranslationsWithPredicate:(NSPredicate *)predicate {
    return [TranslationInfo MR_findAllWithPredicate:predicate];
}

@end
