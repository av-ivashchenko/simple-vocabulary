//
//  NSString+Characters.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/24/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "NSString+Characters.h"

@implementation NSString (Characters)

- (BOOL)hasRussianCharacters {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:kRusCharacters];
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
    
}

- (BOOL)isAlphabeticalStringOnly {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%@%@", kRusCharacters, kEnCharacters]];
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

@end
