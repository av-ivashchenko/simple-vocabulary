//
//  NSString+Characters.h
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/24/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Characters)

- (BOOL)hasRussianCharacters;

- (BOOL)isAlphabeticalStringOnly;

@end
