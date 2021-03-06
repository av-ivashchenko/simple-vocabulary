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

- (void)insertToLocalDatabaseTranslationInfo:(NSDictionary *)translationInfo completion:(SVLocalDatabaseManagerInsertCompletionBlock)completion {
    NSArray *result = [TranslationInfo MR_findByAttribute:kWord withValue:translationInfo[kWord]];
    //save new word+translation if if doesn't exist in local database
    if (result.count == 0) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [TranslationInfo MR_importFromObject:translationInfo inContext:localContext];
        } completion:^(BOOL success, NSError *error) {
            completion(error);
        }];
    }
}

- (NSArray *)fetchAllTranslations {
    return [TranslationInfo MR_findAllSortedBy:kDate ascending:NO];
}

- (NSArray *)fetchTranslationsWithPredicate:(NSPredicate *)predicate {
    return [TranslationInfo MR_findAllSortedBy:kDate ascending:NO withPredicate:predicate];
}

@end
