//
//  NSDictionary+DataValues.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/24/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "NSDictionary+DataValues.h"

@implementation NSDictionary (DataValues)

- (NSString *)translatedText {
    id text = self[kResponseData][kTranslatedText];
    if (text != [NSNull null]) {
        return text;
    } else {
        return nil;
    }
}

@end
