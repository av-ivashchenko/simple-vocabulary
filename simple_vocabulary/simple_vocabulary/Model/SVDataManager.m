//
//  SVDataManager.m
//  simple_vocabulary
//
//  Created by Aleksandr Ivashchenko on 4/23/16.
//  Copyright © 2016 Aleksandr Ivashchenko. All rights reserved.
//

#import "SVDataManager.h"
#import "SVTranslateGateway.h"
#import "SVLocalDatabaseManager.h"
#import "NSString+Characters.h"

@interface SVDataManager ()

@property (nonatomic, strong) SVLocalDatabaseManager *localDatabaseManager;

@end

@implementation SVDataManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _localDatabaseManager = [[SVLocalDatabaseManager alloc] init];
    }
    return self;
}

- (void)translateWord:(NSString *)word {
    
    SVTranslateType type = [self typeForWord:word];
    
    __weak SVDataManager *weakSelf = self;
    
    [[SVTranslateGateway sharedTranslateGateway] translateWord:word
                                                 translateType:type
                                                       success:^(NSString *translation) {
                                                           if ([self checkTranslationCorrectnessForWord:word translationWord:translation]) {
                                                               [weakSelf.localDatabaseManager insertToLocalDatabaseTranslationInfo:@{ @"word": word, @"translation": translation, @"date": [NSDate date] }];
                                                           }
                                                       } failure:^(NSError *error) {
                                                           //inform user about error
                                                       }];
}

- (SVTranslateType)typeForWord:(NSString *)word {
    //if russian
    if (!word) {
        return SVTranslateRusEng;
    //if english
    } else {
        return SVTranslateEngRus;
    }
}

- (BOOL)checkTranslationCorrectnessForWord:(NSString *)word translationWord:(NSString *)translationWord {
    NSLog(@"Word: %@, Translation: %@", word, translationWord);
    
    BOOL isWordLatin = [word canBeConvertedToEncoding:NSISOLatin1StringEncoding];
    BOOL isTranslationWordCyrillic = [translationWord hasRussianCharacters];
    
    if ((isWordLatin && isTranslationWordCyrillic) || (!isWordLatin && !isTranslationWordCyrillic)) {
        NSLog(@"*** Success! Correct web-service response");
        return YES;
    } else {
        NSLog(@"*** Error! Wrong response from the web-service(not correct translation).");
        return NO;
    }
}

@end
