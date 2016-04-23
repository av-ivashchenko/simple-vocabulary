//
//  TranslationInfo+CoreDataProperties.h
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TranslationInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TranslationInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *word;
@property (nullable, nonatomic, retain) NSString *translation;
@property (nullable, nonatomic, retain) NSDate *date;

@end

NS_ASSUME_NONNULL_END
