//
//  NSString+CyrillicCharacters.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/24/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "NSString+CyrillicCharacters.h"

@implementation NSString (CyrillicCharacters)

- (BOOL)hasRussianCharacters:(NSString *)string {
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"];
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
    
}

@end
