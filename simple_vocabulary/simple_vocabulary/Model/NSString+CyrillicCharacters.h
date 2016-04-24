//
//  NSString+CyrillicCharacters.h
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/24/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CyrillicCharacters)

- (BOOL)hasRussianCharacters:(NSString *)string;

@end
