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
                                                           if (translation && [self checkTranslationCorrectnessForWord:word translationWord:translation]) {
                                                               [weakSelf.localDatabaseManager insertToLocalDatabaseTranslationInfo:@{ @"word": word, @"translation": translation, @"date": [NSDate date] }
                                                                                                                        completion:^(NSError *error) {
                                                                                                                            [weakSelf.delegate translateEndedWithError:error.localizedDescription];
                                                                                                                        }];

                                                           } else {
                                                               [weakSelf.delegate translateEndedWithError:[NSString stringWithFormat:@"The translation of the word '%@' is not found.", word]];
                                                                }
                                                       } failure:^(NSError *error) {
                                                           [weakSelf.delegate translateEndedWithError:error.localizedDescription];
                                                       }];
}

- (SVTranslateType)typeForWord:(NSString *)word {
    if ([word hasRussianCharacters]) {
        return SVTranslateRusEng;
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
